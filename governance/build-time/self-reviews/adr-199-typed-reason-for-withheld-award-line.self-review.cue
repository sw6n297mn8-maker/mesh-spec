package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr199TypedReasonForWithheldAwardLine: build_time.#SelfReviewReport & {
	reportId: "srr-adr-199-typed-reason-for-withheld-award-line"

	artifactPath:       "architecture/adrs/adr-199-typed-reason-for-withheld-award-line.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-09-18"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 6
		warnCount: 2
		infoCount: 0
		summary: """
			PREMISSA CENTRAL FALSA. O ADR nascia com três decisões (delta do
			preterido, entrega carimbada, motivo tipado) sustentadas pela tese
			de que a cotação continua mutável depois da decisão. O disco diz o
			contrário: cmd-revise-quotation exige RFQ status=open, e
			inv-negotiated-terms-materialize-on-quotation declara 'toda
			negociação é intra-open'. Com o lifecycle terminal em concluded,
			nenhum comando alcança a cotação — a leitura derivada já é estável
			por construção e não havia instabilidade a congelar.

			Quatro fails acompanharam. (a) A evidência citada para o delta era
			o initialUnitPrice do prj-quotation-map, que no disco é preço
			original vs vigente DO MESMO FORNECEDOR — a economia da negociação
			—, não a diferença entre escolhido e preterido. (b) Faltava a
			alternativa mais forte: o delta é derivável do que o fato já
			congela (fitnessRuleSnapshot + evaluatedSuppliers com determinismo
			garantido pelo agent-spec), logo não havia conhecimento a mudar de
			lugar. (c) A decisão de carimbar deliveryDate no vo-item-award
			contrariava o adr-198, que aplicou P0 a esse mesmo VO com a regra
			'nunca copiam o unitPrice', sem que o ADR citasse o precedente nem
			explicasse a assimetria. (d) reversibility high era indefensável
			contra a definição do schema, e affectedArtifacts omitia
			contexts/ssc/schemas/events.cue e contexts/ssc/api.yaml.

			Warns: 'recibo' como substantivo portante colide com o termo vivo
			do design system e não existe na UL do ssc, enquanto o conceito
			tem morada em term-decision-rationale; e a falsificação dependia de
			superfície de ratificação inexistente.

			Resultado: ADR encolhido de três decisões para uma. O delta caiu
			por derivabilidade; a entrega carimbada caiu por contradizer o
			adr-198; sobrou o motivo tipado, que não é cópia de nada e por isso
			não briga com P0.
			"""
	}, {
		round:     2
		failCount: 3
		warnCount: 1
		infoCount: 0
		summary: """
			COLISÃO DE FRONTEIRA SOBREVIVENTE E FALSIDADE INTRODUZIDA PELA
			CORREÇÃO. (a) A entrada 'sem proposta' da enumeração colidia com o
			outcome no-quotation, que o adr-198 fixou como item sem proposta
			válida de nenhum fornecedor. Pior: o exemplo de roteamento do
			context — 'falta de oferta pede lista ampliada' — era construído
			sobre o caso que, pela taxonomia vigente, NÃO é withheld. O ADR
			estava ilustrado pelo caso errado.

			(b) A razão que substituiu a justificativa circular do defersTo era
			ela própria falsa: 'os sete kinds de #Trigger observam todos o
			repositório' não vale para manual-review ('bypass automático —
			runner não dispara') nem para temporal (tempo decorrido, calculado
			pelo runner como age_days contra a data do def). E a conclusão
			derivada — 'só poderia nascer manual-review' — caía junto, porque
			temporal é machine-evaluable e explicitamente gateável.

			(c) 'Reconvidar os mesmos sinaliza leilão' usava antiTerm
			canonizado com sentido errado: Leilão é lances iterativos públicos;
			o que o ADR descrevia é multi-round/BAFO, que é oq-ssc-9, questão
			ABERTA do BC. O ADR descartava em prosa um mecanismo deixado em
			aberto de propósito.

			Warn: três premissas não declaradas — a desambiguação das causas é
			leitura humana (o que a alternativa B foi rejeitada por propor, com
			a diferença não escrita); o limiar do sinal exige escape acima de
			metade e não pega erosão; e P1 prometia leitura agregada sem
			nenhuma projection planejada.

			O achado (b) é o mais grave da série e de gênero próprio: a
			falsidade não veio da autoria, veio da CORREÇÃO de um finding
			anterior — prosa nova embarcada sem passar pela verificação que
			texto original receberia.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 7
		summary: """
			ZERO FINDINGS. O revisor verificou uma a uma todas as afirmações
			factuais sobre o disco, incluindo as quatro frases reescritas, e
			nenhuma se revelou falsa. As duas imprecisões encontradas são de
			grau e não de fato: um parêntese elidido na citação de
			inv-qualification-as-precondition e uma listagem parcial do que
			prj-rfq-history-by-category agrega — em ambos, a proposição que a
			citação sustenta permanece verdadeira.

			Verificado especificamente: o re-escopo de 'inaptidão documental DA
			RFQ' não admite dupla classificação, porque o ssc não tem command
			de rejeição de cotação pelo comprador e o eixo do npm é disjunto; a
			nova redação do defersTo confere linha a linha contra o schema e
			contra evaluate_deferred_triggers.py, inclusive no ponto
			desconfortável de admitir que temporal é gateável antes de
			argumentar contra; oq-ssc-9 existe e está aberta, e o antiTerm
			Leilão desapareceu do artefato; N2 deixou de contradizer a
			falsificationCondition.

			Sete observações fora de critério foram registradas para leitura do
			founder, não como findings. Duas foram aplicadas como correção de
			precisão após esta rodada: o ponteiro interno que citava a decisão
			(5) onde a proposição literal está na (6), e a marcação explícita
			de que a generalização da falsificação do adr-196 — de 'evento
			emitido' para 'fato' — é deste ADR e não daquele.

			Gates: cue vet ./... EXIT=0; structural-check-runner EXIT=0 com 31
			violações pré-existentes e 0 bloqueantes, nenhuma citando este ADR
			nem artefato do ssc por ele tocado.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				O ADR não tem alarme automático nenhum, e isso é resultado de
				duas escolhas que se somam sem terem sido somadas
				explicitamente. Não há defersTo, pela razão estrutural escrita
				no rationale (nenhum #Trigger alcança dado de produção). E o
				observableSignal exige escape acima da soma das demais
				entradas, limiar que a própria N6 declara grosseiro: uma
				enumeração errada em 25 ou 30 por cento nunca dispara. A
				metade interpretativa do sinal — a leitura de amostra — depende
				de alguém decidir olhar. Nada disso viola critério, e a
				honestidade está no artefato; o que fica sem dono é QUEM olha e
				QUANDO.
				"""
			rationale: "Um ADR cuja falsificação ninguém pode avaliar sozinho é decisão sem vigilância — não é defeito de redação, é calibração que pertence ao founder."
		}, {
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				N3 é a única afirmação do artefato que nenhum revisor pôde
				verificar: a proveniência da enumeração ('desenho de tela e uma
				sessão com usuário sintético, NÃO trabalho de campo com
				construtora'). É auto-declaração de limitação, não afirmação
				sobre artefato do repositório. Registrada aqui porque, numa
				série em que quatro afirmações factuais do autor caíram, a
				única não-verificável merece ser nomeada em vez de herdar a
				confiança das que foram confirmadas.
				"""
			rationale: "Limitação auto-declarada que nenhuma camada de revisão alcança precisa ser visível ao founder como exatamente isso."
		}]
	}

	summary: """
		Três rodadas de revisão isolada contra maxRounds 4, fechando stable
		com zero fails na última. Seis fails no round 1, três no round 2, zero
		no round 3 — e o artefato saiu de três decisões para uma.

		O dado mais importante deste relatório não é a convergência: é que
		QUATRO afirmações factuais sobre o disco, todas escritas pelo agente
		principal com carimbo de verificação, foram derrubadas pela camada
		isolada. A cotação continuar mutável depois da decisão; o
		initialUnitPrice ser o delta do preterido; existir um sinal de
		não-resposta medindo a rede; os sete kinds de #Trigger observarem
		todos o repositório. Nenhuma auto-checagem do agente antecipou
		qualquer uma.

		As três primeiras têm a mesma causa mecânica, identificada e corrigida
		como prática durante a série: grep estreito cujo silêncio foi lido como
		ausência — no caso do ACL do p2p, um filtro que casava duas de cinco
		linhas de campo. A regra que passou a valer: afirmação de NÃO EXISTE ou
		de LISTA COMPLETA exige busca larga e leitura do bloco inteiro, nunca
		da saída filtrada.

		A quarta é de gênero distinto e mais perigoso: nasceu ao CORRIGIR um
		finding do round 1. Prosa de correção foi gerada e embarcada sem passar
		pela verificação que texto original receberia — o caminho do conserto
		tinha menos rigor que o caminho da autoria, exatamente onde a confiança
		já estava abalada. Regra adicionada: prosa de correção passa pela mesma
		verificação que prosa nova; consertar não é editar.

		Isto é dado sobre o valor do rollout adr → isolated-subagent em
		quality-gate.cue, e sobre quanto vale a auto-avaliação do agente como
		gate: menos do que ela mesma reportava. O protocolo do repositório
		exigir revisor sem acesso à conversa para ADR não é cerimônia — nesta
		série foi a única camada que funcionou.

		Três decisões do founder resolveram o que revisão não resolve, porque
		eram escolha e não erro: o escopo do motivo tipado (só withheld, com o
		roteador lendo outcome para no-quotation); a forma da enumeração
		(fechada com escape tipado, contra a estritamente fechada); e, depois
		da rodada 3, em 2026-09-19, a extensão da decisão 3 à entrada 'preço
		fora de faixa'. A segunda mudou o eixo do ADR — o escape deixou de ser
		válvula e virou instrumento, porque a incompletude da enumeração passa
		a ser contável em vez de sumir na prosa.

		A terceira decisão foi tomada sobre a observação (a) do round 3, que o
		revisor registrou FORA de critério. Razão do founder: a decisão 3
		existe para travar fronteira, e 'preço fora de faixa' tem fronteira da
		mesma classe no outro eixo — travar um lado e calar sobre o outro faz o
		silêncio ser lido como ausência de risco em vez de adiamento. A
		distinção escrita no artefato foi verificada contra o disco antes de
		entrar: act-detect-suspicious-quotation existe, é read-only sobre
		prj-rfq-history-by-category, e a spec do agente nomeia 'rejeição da
		cotação' apenas como consequência humana possível — busca larga por
		cmd-reject/reject-quotation em todo contexts/ não devolve comando algum
		no ssc.

		CALIBRAÇÃO DERIVADA, registrada pelo founder: quando o próprio agente
		levanta um ponto de fronteira que ele mesmo reconhece ser 'da mesma
		classe' de um já resolvido como finding, isso é finding — não
		observação no fim do relatório. Reportar na cauda faz a decisão depender
		de o leitor chegar até o fim, o que é o mesmo defeito estrutural que a
		falsificationCondition deste ADR tenta evitar com a leitura de amostra.

		Findings residuais: dois warns declarados acima. Nenhum fail pendente.
		"""
}
