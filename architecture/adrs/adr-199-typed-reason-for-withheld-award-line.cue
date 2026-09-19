package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr199: artifact_schemas.#ADR & {
	id:    "adr-199"
	title: "Tipar o motivo da linha retirada da adjudicação no ssc"

	date: "2026-09-18"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	context: """
		A conclusão de uma RFQ não exige adjudicação total. O adr-198
		materializou a linha vazia com nome e distinguiu dois modos de sair:
		no-quotation, que o adr-198 descreve como item sem proposta válida de
		nenhum fornecedor; e withheld, que registra a linha que a compradora
		deixa sem destino DELIBERADAMENTE, com narrative obrigatória.

		A fronteira é de AUTORIA, não de causa. no-quotation absorve tudo que
		deixa a linha sem cotante válido sem que ninguém decida: ausência de
		propostas, cotação com status=withdrawn e exclusão automática do
		fornecedor rebaixado (inv-qualification-as-precondition: 're-validation
		antes de emitir decisão. Fornecedor rebaixado entre os pontos é
		excluído automaticamente'). Nesses casos a regra já está escrita — 'linha
		sem cotante válido não gera entradas — o vo-item-award correspondente
		registra no-quotation'. withheld é o que sobra: havia com o que
		adjudicar, e uma pessoa escolheu não fazê-lo.

		Só withheld tem motivo a declarar. E hoje ele só existe como texto
		livre: a narrative registra que houve um motivo, não permite ler QUAL
		por linha, por categoria, ao longo do tempo. A pergunta operacional da
		compradora — 'quais linhas saíram pelo mesmo motivo' — não se responde
		sobre prosa.

		E o motivo é o ROTEADOR do que acontece depois. Ilustração, não
		decisão: prazo inviável dificilmente se resolve ampliando a lista,
		porque lista maior não cria prazo onde a restrição é de capacidade de
		mercado; especificação incorreta volta ao requisitante, que é outro
		caminho inteiro; e re-submeter aos MESMOS fornecedores não é ampliação
		— é multi-round, que o BC deixou deliberadamente em aberto (oq-ssc-9) e
		que este ADR não decide nem descarta. O roteamento em si é decisão do
		ADR próprio (decisão 6); o que esta ilustração mostra é que destinos
		diferentes dependem de saber o motivo, e um roteador determinístico não
		lê prosa.

		Verificado no disco: vo-item-award carrega itemId, outcome,
		awardedSupplierRef, awardedQuotationRef e narrative. Não há motivo
		tipado.

		RELAÇÃO COM O adr-198, que criou este value object e lhe aplicou P0.
		O adr-198 decidiu que 'o item-award e a linha de aprovação referenciam
		por itemId/quotationRef, nunca copiam o unitPrice' — o preço tem casa
		canônica na linha da cotação e o award aponta para ela. O motivo
		tipado NÃO é dessa classe: é informação que a compradora PRODUZ no ato
		da decisão, sem dono em lugar nenhum do modelo. Tipá-lo CRIA uma
		localização; não duplica uma existente. A distinção precisa estar
		escrita porque as duas decisões tocam o mesmo VO, e um leitor futuro
		que encontre 'nunca copiam' ao lado de um campo novo tem direito de
		saber por que não há contradição.

		Alternativas consideradas. (B) Manter só a narrative e extrair o
		motivo por leitura no momento do roteamento. Rejeitada: faria o
		roteador depender de interpretação de prosa — gate estocástico
		disfarçado, contra P10, exatamente onde a Mesh promete portão
		determinístico. (C) Pôr o motivo no objeto do reencaminhamento, não no
		award. Rejeitada: a linha withheld existe seja ela reencaminhada ou
		não, e o motivo se perderia justamente nas linhas que saem e nunca
		voltam. (D) Enumeração ESTRITAMENTE fechada, sem escape. Rejeitada
		porque o próprio risco desta decisão a derruba: a enumeração nasce de
		desenho, não de campo, e conjunto fechado incompleto empurra o uso
		para a narrative livre — a falha que a tipagem veio evitar. O escape
		tipado transforma essa fuga em contagem legível.
		"""

	decision: """
		(1) outcome=withheld passa a exigir, ALÉM da narrative livre, um
		motivo de enumeração fechada COM ESCAPE TIPADO. As entradas vigentes
		do desenho são cinco — cotante único, preço fora de faixa, prazo
		inviável, especificação incorreta e inaptidão documental DA RFQ — mais
		o escape. Naming final e forma decidem-se na fatia sob o glossário do
		ssc (precedente adr-196 decisão 3).

		(2) O ESCAPE é tipado, não ausência de tipo: a linha cujo motivo não
		cabe na enumeração recebe o valor de escape e a narrative carrega o
		caso. A diferença com (D) é que a linha fica visível COMO não-cabendo,
		em vez de desaparecer na prosa — e a incompletude da enumeração vira
		contagem, que é o sinal da falsificationCondition abaixo.

		(3) 'INAPTIDÃO DOCUMENTAL DA RFQ' É ESCOPO ESTREITO E PRECISA SER LIDO
		COMO TAL: cobre exigência documental do ESCOPO daquela cotação — ART,
		certificado técnico, apólice de seguro pedidos no item — e NÃO o eixo
		eligible-for-sourcing do npm. Qualificação de participante é domínio do
		npm e resolve-se por gate automático antes de haver decisão
		(inv-qualification-as-precondition); fornecedor rebaixado ali nem chega
		à mesa, e a linha que ele esvazia é no-quotation, não withheld. O que
		esta entrada cobre é juízo da compradora sobre documento pedido NA
		RFQ, que o npm não conhece. Sem esta distinção escrita, a entrada
		reabre a fronteira que o adr-198 fixou.

		'PREÇO FORA DE FAIXA' CARREGA FRONTEIRA DA MESMA CLASSE, NO OUTRO
		EIXO, e pede a mesma leitura estreita: a entrada cobre a COMPRADORA
		decidir não adjudicar a linha a um cotante cujo preço ela julga fora
		de faixa. NÃO cobre a rejeição da COTAÇÃO como ato próprio — do
		sistema ou do avaliador de regras. A detecção estatística de
		fora-de-range já existe e é outra coisa: act-detect-suspicious-quotation
		compara contra prj-rfq-history-by-category, é read-only, e a spec do
		agente nomeia 'rejeição da cotação' apenas como uma das consequências
		humanas possíveis — nenhum comando a materializa hoje. Quando existir,
		opera sobre a ent-quotation e não sobre a linha do award: eixo
		distinto. Sem esta distinção escrita, a decisão travaria um lado da
		fronteira e calaria sobre o outro, e o silêncio seria lido como
		ausência de risco em vez de adiamento.

		(4) O MOTIVO TIPADO APLICA-SE APENAS A withheld. no-quotation NÃO o
		recebe: ninguém decidiu, logo não há motivo a declarar. O outcome já
		registra o fato.

		(5) CONSEQUÊNCIA DIRETA DE (4): o roteador do reencaminhamento tem
		DUAS entradas, não uma — lê o outcome quando a linha é no-quotation e
		o motivo tipado quando é withheld. E o lado no-quotation NÃO é
		homogêneo: ausência de propostas, cotação retirada e exclusão por gate
		produzem o mesmo outcome e pedem caminhos diferentes (ninguém cotou
		pede lista ampliada; único cotante desqualificado pede habilitação no
		npm). Separá-las é trabalho do ADR do roteamento; registrar que
		precisam ser separadas é trabalho deste, porque quem escrever aquele
		não deve descobrir por acidente.

		(6) O ROTEAMENTO em si NÃO é decidido aqui. Este ADR cria o campo; o
		outro cria o destino. O campo tem valor isolado: a leitura agregada de
		por que linhas saem passa a existir sem que nenhum destino exista.

		(7) DEPENDÊNCIA NOMEADA: o gatilho da recusa da contraparte — a linha
		que sai porque o fornecedor recusou o compromisso, DEPOIS do pedido —
		não é coberto por esta enumeração. Ele depende do causeType do cmt,
		enum diferente em contexto diferente, cuja fatia é o WI-164. Fora do
		escopo deste ADR, e declarado para não ser procurado aqui.

		(8) OS ESPELHOS decidem-se na fatia sob P14. contexts/ssc/api.yaml
		declara explicitamente que representa outcome ABERTO porque o domínio
		o deixa indicativo ('o espelho não fecha o que o domínio não fecha').
		O motivo nasce fechado-com-escape no domínio — se o espelho reproduz o
		fechamento ou o mantém aberto é decisão da fatia sob a mesma doutrina,
		não deste ADR.
		"""

	consequences: """
		Positivas — P1: a leitura agregada de retirada passa a ser POSSÍVEL
		sobre dado tipado. Possível, não disponível: nenhuma projection ou
		queryCapability é planejada aqui, e prj-quotation-map é por RFQ
		enquanto prj-rfq-history-by-category agrega preço e cancelamento, não
		motivos. P2: o roteamento ganha entrada determinística quando for
		decidido, sem reabrir este VO. P3: a linha que sai deixa de ser evento
		opaco — o adr-198 lhe deu nome, e este lhe dá causa. P4: a
		incompletude da enumeração deixa de ser invisível: o escape a torna
		contável.

		Negativas — N1: campo novo em VO que viaja no evt-sourcing-decision-
		made, published — propagação às superfícies geradas dos runtimes. O
		ACL do p2p não é afetado: a tradução evt-sourcing-decision-made-
		received NÃO carrega itemAwards — zero ocorrências de itemAward em
		todo contexts/p2p/, enquanto o evento publicado de origem os carrega.
		N2: o escape tipado pode virar o valor preguiçoso padrão — quem não
		quer escolher escolhe ele, e a enumeração morre por desuso em vez de
		por incompletude. A contagem sozinha não distingue as duas causas; a
		falsificationCondition prescreve a leitura de amostra que distingue.
		N3: a enumeração nasceu de desenho de tela e de uma sessão com usuário
		sintético, NÃO de trabalho de campo com construtora. N4: o campo nasce
		sem o roteador (decisão 6) e sem consumidor de leitura (P1) —
		preenchido, com efeito ainda inexistente. O adr-196 nomeia este risco
		na própria falsificação, sobre evento emitido; a generalização para
		CAMPO sem leitor é deste ADR, não daquele.
		N5: a pergunta de P14 sobre os dois espelhos é transferida à fatia.
		N6: o limiar do sinal abaixo é grosseiro por construção — uma
		enumeração substancialmente errada, com escape em 25 ou 30 por cento,
		não o dispara. Ele pega o colapso, não a erosão.
		"""

	falsificationCondition: {
		condition:        "Concentração das linhas withheld no valor de escape, com a verificação incluindo LEITURA DE AMOSTRA das narratives correspondentes — sem a leitura, a contagem é alarme e não instrumento. Duas causas opostas produzem o mesmo número e só a amostra as separa: narratives divergentes entre si indicam enumeração incompleta (o conjunto não cobre a prática); narratives repetitivas ou vazias indicam escape preguiçoso (escolher virou custo que ninguém paga). A leitura é revisão humana pós-fato sobre fatos já registrados, não gate de runtime — por isso não recai na rejeição da alternativa (B), que era sobre decidir roteamento interpretando prosa."
		observableSignal: "Proporção de linhas withheld com o valor de escape acima da soma das demais entradas, mais a leitura de amostra das narratives dessas linhas. Observável sobre os próprios fatos, sem depender de superfície nova."
	}

	affectedArtifacts: [
		"contexts/ssc/domain-model.cue",
		"contexts/ssc/schemas/events.cue",
		"contexts/ssc/api.yaml",
		"contexts/ssc/glossary.cue",
		"contexts/ssc/agents/ssc-primary-agent.cue",
	]

	principlesApplied: [
		"P10 — o roteamento por motivo exige entrada determinística; extrair o motivo de prosa livre, como propunha a alternativa (B), seria gate estocástico disfarçado no ponto exato em que o sistema promete portão determinístico.",
		"P0 — o motivo tipado não é cópia: não existe casa canônica dele fora do item-award. A aplicação de P0 que o adr-198 fez a este mesmo VO — preço referenciado, nunca copiado — não é contrariada, porque lá havia dono e aqui não há.",
	]

	rationale: """
		Tipo e prosa juntos, e não um no lugar do outro, porque respondem
		perguntas diferentes: o tipo responde 'quantas linhas saíram por preço
		fora de faixa neste trimestre' e a prosa responde 'o que houve nesta
		linha'. Trocar um pelo outro perde metade em qualquer direção.

		O escape tipado é a escolha menos óbvia e a mais defensável. Uma
		enumeração fechada nascida de desenho, e não de campo, tem
		probabilidade alta de estar errada; o que muda entre estar errada e
		saber que está errada é ter para onde mandar o que não cabe. Sem o
		escape, o erro migra para a narrative e fica invisível — e o sinal que
		denunciaria a enumeração some junto.

		Só withheld recebe motivo porque só ele tem autor. A fronteira com
		no-quotation é de autoria e não de causa, e as duas entradas que mais
		tentam atravessá-la ficaram ancoradas: 'cotante único' é retirada
		deliberada legítima porque o caminho governado existe e é por linha —
		inv-competitive-pool-or-supervised-exception exige supervisedDecision
		approve-decision-with-insufficient-pool NA LINHA, e recusar essa
		exceção é o ato deliberado que withheld registra; 'inaptidão
		documental da RFQ' precisou de escopo escrito na decisão (3) porque
		sem ele colide com o gate de elegibilidade do npm.

		A relação com o adr-198 é de extensão, não de tensão, e está escrita
		no context porque o mesmo VO carrega uma regra de não-cópia que um
		leitor futuro poderia ler como contrariada. A relação com o adr-196 é
		de precedente em dois pontos: o adiamento de naming à fatia sob o
		glossário, e a declaração de dependência nomeada em vez de espera.

		Reversibility medium, não high: o campo viaja em evento published, e o
		schema reserva high para o que se reverte sem impacto em contrato
		público. Pré-MVP e sem migração de dados, mas contrato público é
		contrato — e o veredito não depende de quem consome, porque published
		basta. O adr-198, mudança comparável no mesmo VO e no mesmo evento,
		calibrou medium. blastRadius cross-artifact: cinco artefatos dentro do
		ssc, com a não-propagação ao p2p verificada.

		OMISSÃO DECLARADA de defersTo, com a razão correta e não com a fácil.
		O risco da enumeração só se observa sobre dado de PRODUÇÃO — a
		distribuição real dos motivos nas linhas withheld. Dos sete kinds de
		#Trigger, o único machine-evaluable que alcançaria este caso é
		temporal (maxAgeDays): ele EXISTE e é gateável, e seria desonesto
		dizer que não há opção automática. É inadequado por outra razão — conta
		tempo desde a criação do deferimento, que não guarda relação nenhuma
		com a existência do dado que o risco exige; num repositório pré-MVP
		ele acordaria antes de haver o que medir, produzindo ruído sem sinal, e
		o próprio schema o reserva como último recurso com justificativa forte.
		Os cinco kinds restantes observam o repositório e não alcançam dado de
		runtime; manual-review não observa nada e o regime manda não usá-lo
		como default por preguiça. Por isso o risco mora na
		falsificationCondition — a categoria que o schema do #ADR reserva ao
		que invalida a decisão — e não em deferimento governado.
		"""
}
