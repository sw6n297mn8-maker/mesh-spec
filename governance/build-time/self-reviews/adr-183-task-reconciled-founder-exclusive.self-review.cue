package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr183TaskReconciledFounderExclusive: build_time.#SelfReviewReport & {
	reportId: "srr-adr-183-task-reconciled-founder-exclusive"

	artifactPath:       "architecture/adrs/adr-183-task-reconciled-founder-exclusive.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-08-01"

	roundsExecuted: 7
	maxRounds:      4

	status: "max-rounds-reached"

	roundDetails: [{
		round:     1
		failCount: 6
		warnCount: 3
		infoCount: 0
		summary: """
			PRECEDENTE HISTÓRICO FALSO. O context construía a tese sobre "três
			ocasiões em que o repo escolheu documentar em vez de fabricar
			evento retroativo". Verificação na fonte: o adr-024 decision item
			(3) decidiu o OPOSTO ("backfill retroativo de tarefas já
			concluídas"); duas das três ocasiões eram a mesma (o cabeçalho do
			wi-140 é bloco único); e a prática dominante do repo é backfill.
			Round fatal — o ADR foi reformulado por inteiro sobre bootstrap vs
			steady state. Gerou o erratum do wi-043 (PR #226), porque a mesma
			afirmação falsa já estava em main.
			"""
	}, {
		round:     2
		failCount: 3
		warnCount: 2
		infoCount: 0
		summary: """
			INCOERÊNCIA INTERNA. N3 subestimava o custo; o context atribuía a
			WI-069 conferência de outputs que sua task-spec torna impossível
			(outputs: []); a justificativa de reversibility lia a escala do
			schema INVERTIDA (atribuía migração de dados a low, quando o
			schema a atribui a medium). Warns: dec 1 tornava (rejected,
			completed) alcançável, e "none" não pertence a
			executionStateMachine.states.
			"""
	}, {
		round:     3
		failCount: 2
		warnCount: 4
		infoCount: 0
		summary: """
			PROMESSA SEM ENTREGA FORA DA FRONTEIRA. P12 declarado aplicado
			enquanto N7 documentava que nenhum runner executa os ev-*; e P1
			prometia estado derivado correto sem tocar scripts/ci/
			rebuild-projections.sh, cujo compute_state nunca produz "defined".
			Warns: par (defined, completed) absorvente, prova vazia para output
			type update, ganho de destravar dependentes vazio, contagem de N3
			não-exaustiva.
			"""
	}, {
		round:     4
		failCount: 4
		warnCount: 2
		infoCount: 0
		summary: """
			REFERENTE INEXISTENTE E CONTAGEM ERRADA. A "fatia de saneamento"
			para a qual o ADR delegava seis itens não existia no disco (zero
			def, zero WI, defersTo vazio); N1 contava 7 regras ev-* quando o
			pipeline efetivo declara 11 (união com claim-expiration-validation
			e completion-gates); N3 apontava para N4 como se este capturasse o
			errorCorrection.compensatoryEvents, e não capturava; dec 5b tinha
			referência estagnada da renumeração. Round que motivou o
			levantamento da superfície do motor e o encolhimento do escopo.
			"""
	}, {
		round:     5
		failCount: 4
		warnCount: 2
		infoCount: 0
		summary: """
			Primeira passada sobre a versão ENCOLHIDA. Confirmou que o eixo
			histórico e as rotas alcançáveis fecham como declarado, e que o
			dec 7 tem portador real. Fails remanescentes: a delegação seguia
			sem artefato portador; N1 mantinha a contagem errada; N4 não
			contava o errorCorrection; dec 5b citava N2/N7 em vez de N1/N6.
			"""
	}, {
		round:     6
		failCount: 4
		warnCount: 2
		infoCount: 0
		summary: """
			Review conjunto com o def-083 recém-criado. No ADR: dec 5b
			caracterizava a rota R2 como "sem a cadeia claim→complete", e o
			exemplar citado (wi-043) TEM task-claimed registrado -- o que
			faltava era a prova contemporânea, não o registro. Warns: nenhum
			dos dois artefatos tinha self-review report (gate bloqueante), e
			taskCompletion.requires ficava falso com dois caminhos para
			completed. Correções aplicadas; N4 foi a QUINZE pontos.
			"""
	}, {
		round:     7
		failCount: 2
		warnCount: 0
		infoCount: 2
		summary: """
			REGRESSÃO INTRODUZIDA PELA CORREÇÃO ANTERIOR, e delegação para
			referente vazio. (1) O dec 7 descrevia os triggers do def-083 como
			"recurrence sobre streams novos" -- a versão DESCARTADA no round 6
			por nascer disparada. Corrigi o def e não corrigi o ADR que o
			descreve: referência estagnada da classe exata que o próprio dec 7
			diz evitar. (2) N9 e o bloco FRONTEIRA delegavam ao def-083 dois
			itens ausentes da enumeração -- o instrumento da razão do dec 8 e a
			expiração de claim -- e ainda afirmavam que a fatia estava
			"registrada em def-083 com os onze achados enumerados". Promessa
			apontando para o que o portador não carrega.

			Correção do (2) por rota própria, não a sugerida: os onze
			permanecem como MAPA DO DISCO e o def ganha seção ITENS DELEGADOS
			com proveniência distinta (D1, D2). Fundir as origens faria o
			número flutuar a cada delegação futura.

			Verificação minha sobre o achado (2) endureceu o fundamento: as
			ev-08/09/10 validam o task-claim-expired QUANDO emitido e nenhuma
			o dispara -- a lacuna é a DETECÇÃO, declarada no
			rebuild-projections.sh ("Claim expiration is NOT auto-detected").

			Info: as duas observações fora de critério sobre o ADR (quarta
			sentença candidata em admissionStateMachine.rationale; precisão do
			aposto de N2 para a origem approved/unclaimed) -- ambas aplicadas.

			Tudo o mais conferiu contra o disco: as três contagens (QUINZE
			pontos, ONZE regras, ONZE achados), as quatro rotas de origem
			cruzadas com validStatePairs, a tabela inteira de citações, e
			nenhuma referência interna estagnada.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-09"
			severity:    "warn"
			message: """
				A camada que pegou o defeito mais consequente do round 7 NÃO
				foi o review isolado: o regex sc-wg-0[2-9] do sensor novo
				passou pela minha autoria E pelo review, e o founder o
				derrubou com uma pergunta -- "e se o fiscal nascer como
				sc-wg-10+?". Verificação: o repo tem sc-dlv-14 e sc-rew-15, 11
				das 126 ids em >= 10. Registrado como warn e não omitido
				porque contradiz a tese confortável do summary: nem a camada
				isolada é suficiente.
				"""
			rationale: "Um report que só registra os acertos do mecanismo que o produziu não é evidência, é propaganda."
		}, {
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				As contagens por round são RECONSTRUÍDAS do que foi reportado
				ao founder durante a sessão, não de artefato persistido: as
				saídas dos review subagents não são gravadas em lugar nenhum do
				repo. O subagent-execution-log.cue registra dispatches de
				AUTHORING, não de review. Numa sessão em que quatro contagens
				erradas foram corrigidas, a limitação precisa estar declarada
				em vez de suposta.
				"""
			rationale: "Lacuna de instrumentação nomeada: reviews isolados não deixam rastro auditável no repo."
		}]
	}

	summary: """
		ADR de custo excepcional: SETE rounds de review isolado contra
		maxRounds 4 -- por isso status max-rounds-reached, não stable. Cada
		round encontrou defeito real e de natureza diferente: precedente
		histórico falso (R1), incoerência entre decision items (R2), promessa
		não entregue por artefato fora da fronteira declarada (R3), referente
		inexistente e contagem errada (R4), resíduos do encolhimento (R5),
		caracterização errada de rota e ausência de SRR (R6), regressão
		introduzida pela correção do round anterior e delegação para referente
		vazio (R7). Nenhuma auto-checagem do agente principal antecipou
		qualquer um deles -- em todos os sete rounds, a camada que pegou foi a
		isolada. Isso é dado sobre o valor do rollout adr ->
		isolated-subagent em quality-gate.cue, e sobre o quanto a
		auto-avaliação do agente vale como gate: menos do que ele vinha
		reportando.

		Com uma exceção que o warn uq-09 registra e que corta na direção
		contrária: o defeito de maior alcance da última fatia -- o regex do
		sensor limitado a nove checks num repo com famílias em 14 e 15 --
		passou pelas DUAS camadas e foi pego pelo founder. R7 também exibe o
		modo de falha específico de linhas longas: a correção de um round
		vira o defeito do seguinte quando o artefato corrigido é descrito em
		outro lugar.

		O ADR foi ENCOLHIDO no R5 por decisão do founder, após levantamento da
		superfície real do motor de work-governance: passou a decidir
		vocabulário e autoridade, delegando enforcement, derivação e projeções
		ao def-083. O encolhimento foi consequência direta do padrão dos
		rounds -- cada um mostrava a fronteira declarada estreita demais.

		Findings residuais: dois warns declarados acima -- um sobre o limite
		demonstrado do próprio mecanismo de review, outro sobre a lacuna de
		instrumentação que impede reconstituir os rounds a partir do repo.
		Nenhum fail pendente: os dois do round 7 foram corrigidos, e as quatro
		observações fora de critério (duas no ADR, duas no def) foram todas
		aplicadas por decisão do founder.

		DESFECHO. Após leitura integral dos dois artefatos, o founder aprovou o
		flip proposed -> accepted em 2026-08-01, com date preservada. O que
		accepted significa aqui, dito sem eufemismo para que ninguém leia mais
		do que está: NÃO destrava a reconciliação de WI-067, WI-069 e WI-151 --
		o dec 4 exige o tipo concreto, e sem os quinze pontos do N4
		materializados o eventType nem passa em cue vet. Destrava a fatia de
		materialização do motor. E o repo passa a ter uma decisão ACEITA cujo
		dec 7 declara não ser gate em execução e cujo N1 declara o motor sem
		fiscal -- ambas escritas em voz alta no artefato, e é essa honestidade
		que torna o accepted defensável.
		"""
}
