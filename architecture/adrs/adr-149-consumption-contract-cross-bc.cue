package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr149: artifact_schemas.#ADR & {
	id:    "adr-149"
	title: "Adotar contrato-de-consumo como mecanismo de consumo cross-BC de eventos"
	date:  "2026-06-13"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		def-057 deferiu, em n=1 (o espelho #InvoiceIssued no FCE — cópia
		verbatim do canônico do INV), a decisão do mecanismo de consolidação
		de eventos consumidos cross-BC. A família de PROTOCOLO de eventos
		cross-BC vive em ADR: adr-104 (identidade de evento) e adr-105
		(sc-cm-06, que resolveu def-019) fixaram que um evento é propriedade
		canônica do BC que o produz. Isto é distinto da CONSOLIDAÇÃO de shape
		compartilhado por convenção (def-022→shared-schemas/envelope.cue,
		def-025→shared-schemas/money.cue) — aquele caminho resolve sem ADR,
		apontando o artefato compartilhado.

		Trigger (n=2): a Etapa 2 da fatia REW materializou RiskEvaluationEmitted
		(contexts/rew/schemas/events.cue). O FCE carregava a fixture
		#EligibilityEmitted — um EVENTO que o REW nunca emite. A reconciliação
		(Etapa 3) revelou que o que o FCE consome é um SUBCONJUNTO de facetas de
		RiskEvaluationEmitted (eligibility + context), não um evento autônomo: o
		PrePaymentGuard lê parte do fato unificado do REW. Com o espelho
		InvoiceIssued (projeção-do-todo) e o #EligibilityConsumption
		(projeção-de-parte), há duas
		instâncias concretas (n=2) — a disciplina de promoção por evidência
		(precedente def-022/def-025, que só consolidaram no 2º consumidor real)
		autoriza decidir o mecanismo agora.

		Alternativas consideradas (as opções a–d declaradas em def-057):

		(a) Import cross-BC no CUE (o schema do consumidor importa o package do
		    produtor) + suporte do gerador a refs cross-contexto. REJEITADA:
		    acopla o build do consumidor ao package do produtor, exige resolução
		    cross-contexto no gerador (custo material no mesh-runtime), e não
		    expressa consumo PARCIAL — importar o tipo inteiro não diz que só as
		    facetas eligibility + context são lidas.

		(b) Promover o evento a architecture/shared-schemas/ por par
		    produtor-consumidor (precedente def-022/def-025). REJEITADA:
		    shared-schemas é para shape compartilhado POR CONVENÇÃO (envelope,
		    money) idêntico entre BCs; um evento consumido é o FATO de um
		    produtor, não um shape comum — promovê-lo apaga o ownership do
		    produtor (contradiz adr-104/sc-cm-06).

		(c) Espelho disciplinado vira regra, com structural-check de identidade
		    espelho↔canônico (diff mecânico em CI). REJEITADA como mecanismo
		    ÚNICO: serve projeção-do-todo (espelho verbatim de InvoiceIssued)
		    mas NÃO expressa projeção-de-parte — a eligibility é um SUBCONJUNTO
		    de RiskEvaluationEmitted, e um diff de identidade não valida uma
		    projeção parcial.

		(d) Contrato-de-consumo: o consumidor declara que consome uma PROJEÇÃO
		    de uma faceta do fato do produtor. ESCOLHIDA — subsume (a)/(c) ao
		    expressar tanto o todo quanto a parte, e preserva o ownership que
		    (b) destrói.
		"""

	decision: """
		(1) ESTABELECER o contrato-de-consumo como mecanismo canônico de consumo
		cross-BC de eventos: o schema do consumidor declara, via campos hidden
		(_consumesEvent = o type canônico do fato do produtor; _projectsFacets =
		as facetas projetadas), que consome uma PROJEÇÃO do fato do produtor —
		não uma cópia do evento. Os campos não-hidden do tipo são o subconjunto
		efetivamente lido pelo consumidor.

		(2) RECONHECER duas expressões do MESMO mecanismo: (a) projeção-do-todo
		(espelho — o consumidor projeta o fato inteiro, incluindo envelope;
		ex.: #InvoiceIssued no FCE) e (b) projeção-de-parte (subset — o
		consumidor projeta um subconjunto de facetas sem envelope; ex.:
		#EligibilityConsumption no FCE, as facetas [eligibility, context] de
		RiskEvaluationEmitted).

		(3) SUBORDINAR o ownership do fato ao produtor (per adr-104/sc-cm-06): o
		contrato-de-consumo declara dependência projetada, NÃO transfere
		ownership. _consumesEvent é PONTEIRO para o type canônico do produtor
		(P0: ponteiro, não cópia) — o produtor permanece a autoridade do fato.

		(4) ESCOPAR a afirmação ao que n=2 prova (projeção-do-todo InvoiceIssued
		+ projeção-de-parte #EligibilityConsumption). Aplicabilidade universal a todo
		consumo cross-BC é INTENT declarada, NÃO afirmação provada; a revisita é
		em n=3 (o próximo fato consumido cross-BC — ex.: a materialização do
		#SettlementFinalized do BKR), per falsificationCondition.

		(5) RESOLVER def-057 (o mecanismo deferido = opção d) e def-059 (o
		fantasma #EligibilityEmitted removido na Etapa 3 Section B).
		"""

	consequences: """
		Positivas:
		(P1) Elimina a classe de drift "fixture de evento que o produtor não
		emite": o fantasma #EligibilityEmitted não renasce, porque o mecanismo
		força declarar consumo-de-faceta de um fato REAL do produtor
		(_consumesEvent aponta o type canônico existente).
		(P2) Expressa consumo PARCIAL nativamente (_projectsFacets) — o que o
		espelho-verbatim (opção c) não alcança: o guard lê só as facetas
		eligibility + context sem copiar RiskEvaluationEmitted inteiro.
		(P3) Preserva o ownership do produtor (adr-104) sem acoplar o build do
		consumidor ao package do produtor — evita o custo da opção (a) no
		gerador (sem resolução cross-contexto).
		(P4) Unifica espelho (n=1) e subset (n=2) sob um mecanismo com duas
		expressões — reduz o vocabulário de mecanismos cross-BC de dois
		(espelho + import) para um.

		Negativas:
		(N1) Em Phase 0 os campos hidden (_consumesEvent/_projectsFacets) são
		convenção sem structural-check ativo. A identidade faceta↔fato-do-
		produtor NÃO fica sem verificação no interino: é verificada por (i)
		review do founder no PR e (ii) grep do type-string — _consumesEvent
		carrega o type canônico literal (ex.: "mesh.rew.risk-evaluation-
		emitted.v1"), conferível por grep contra o schema do produtor. O
		structural-check mecânico (diff de identidade) fica deferido como
		known-gap; é o mesmo gap que def-057 notou para o espelho, agora com o
		type-string como âncora grep-ável.
		(N2) A aplicabilidade universal é INTENT não provada em n=2 — risco de
		generalizar cedo; mitigado pelo gatilho de revisita em n=3
		(falsificationCondition).
		(N3) #InvoiceIssued (n=1) permanece na grafia espelho-verbatim (cópia
		dos 7 campos + comentário "NÃO DIVERGIR" + ponteiro def-057), sem a
		annotation hidden-field; #EligibilityConsumption (n=2) usa a grafia
		hidden-field. As duas grafias coexistem como expressões legítimas do
		mesmo mecanismo (o todo carrega envelope; a parte não); a
		retro-annotation do n=1 para a notação hidden-field é known-gap de
		follow-up change-on-touch — não justifica tocar InvoiceIssued nesta
		Etapa.

		Fronteira regulatória: nenhuma diretamente. O contrato-de-consumo é
		mecanismo de design de schema (como um BC consome o fato de outro), não
		decisão operacional de movimento de dinheiro.
		"""

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	falsificationCondition: {
		condition: """
			Este mecanismo estará errado SE um 3º fato consumido cross-BC (n=3 —
			ex.: o #SettlementFinalized do BKR ao materializar seu schema) NÃO
			couber em projeção-do-todo nem em projeção-de-parte, exigindo uma
			terceira expressão ou um mecanismo distinto. Nesse caso a afirmação
			de "um mecanismo, duas expressões" cai e o ADR é revisitado.
			"""
		observableSignal: """
			A materialização de um schema de produtor cujo consumo no FCE (ou em
			outro BC) não se exprime via _consumesEvent + _projectsFacets —
			visível no PR que introduz o consumo. A materialização do BKR
			(SettlementFinalized) é o próximo gatilho concreto: os forward-refs
			em contexts/fce/{schemas/events,domain-model}.cue apontam este ADR.
			"""
	}

	affectedArtifacts: [
		"contexts/fce/schemas/events.cue",
		"contexts/fce/domain-model.cue",
		"contexts/fce/canvas.cue",
		"contexts/fce/golden-examples/prepayment-guard-terminal.cue",
		"contexts/rew/schemas/events.cue",
		"architecture/deferred-decisions/def-057-cross-bc-consumed-event-consolidation.cue",
		"architecture/deferred-decisions/def-059-remove-eligibility-emitted-phantom.cue",
	]

	principlesApplied: ["P0", "P13"]

	rationale: """
		Opção (d) entre (a)–(d): subsume o espelho (projeção-do-todo) e o subset
		(projeção-de-parte) num único mecanismo, preservando P0 (ponteiro via
		_consumesEvent, não cópia) e o ownership canônico do fato pelo produtor
		(P13: ownership canônico de um conjunto de fatos; ancorado em adr-104
		identidade de evento / sc-cm-06). (a) falha o consumo parcial e custa
		resolução cross-contexto no gerador; (b) destrói o ownership do produtor
		ao promover o fato a shape compartilhado; (c) não expressa subset. A
		escolha é dirigida por evidência n=2 (InvoiceIssued + eligibility), não
		por n=1 — a mesma disciplina de promoção por evidência que def-022/
		def-025 exercitaram (consolidação só no 2º consumidor real).

		Escopo e honestidade da afirmação: a universalidade do mecanismo é INTENT
		declarada, não provada — registrada como tal na decisão (item 4) e
		falsificável em n=3 (BKR), per falsificationCondition. Isto evita o erro
		que def-057 existia para impedir: generalizar de exemplo único.

		Tensão com axiomas: nenhuma. A coexistência temporária de duas grafias
		(espelho-verbatim no n=1, hidden-field no n=2) é known-gap declarado
		(N3), não tensão — ambas são expressões do mesmo mecanismo, e a
		unificação é follow-up change-on-touch.
		"""
}
