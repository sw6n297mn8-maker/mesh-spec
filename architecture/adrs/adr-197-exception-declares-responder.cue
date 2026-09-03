package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr197: artifact_schemas.#ADR & {
	id:    "adr-197"
	title: "Instituir que toda exceção declarada nomeia quem responde"
	date:  "2026-09-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		Cinco aparições independentes, em três superfícies, do padrão 'a
		transição de exceção existe no modelo; quem responde a ela, não'
		foram relatadas pelo founder (origem externa declarada:
		registro-decisao-wireflow.md §11 do projeto do protótipo + PR #27 do
		mesh-frontend-runtime — evidência da mesma natureza citada no log #7
		do laboratório). A verificação em disco (2026-09-03) MUDOU a
		contagem, e a mudança é registrada aqui:

		VERIFICADA PLENA — pool insuficiente na abertura: toda
		escalationRouting do envelope do ssc roteia para recipient 'founder'
		(ssc-primary-agent.governance.cue, rota async-queue cobrindo
		insufficient-qualified-pool entre 5 condições) — placeholder Phase 0
		SILENCIOSO: o schema aceita qualquer string não-vazia
		(#EscalationRoute.recipient: #NonEmptyString, agent-governance.cue)
		e nada distingue destinatário real de placeholder.

		VERIFICADA PARCIAL — suspensão com proposta na mesa: a maquinaria de
		remoção existe e é automática (evt-participant-suspended no npm;
		policy + act-revalidate-qualification removem o rebaixado do pool;
		inv-qualification-as-precondition), mas o DESTINO DA PROPOSTA ÓRFÃ
		não existe no disco — nenhum elemento responde à cotação submetida
		do fornecedor removido. A metade da resposta é evidência relatada.

		RELATADAS COM ORIGEM (nada no disco): terminação como ato com
		responsável (o encerramento existe só como estado terminal) e
		reabertura de cotação encerrada ('reabrir é ato novo' sem ator).

		SAIU DA LISTA, COM NOTA — cancelamento nos três agregados: a
		verificação encontrou cancelledBy nos TRÊS comandos
		(cmd-cancel-purchase-requisition, cmd-cancel-purchase-order,
		cmd-cancel-rfq), todos string nominal. O responder do cancelamento
		EXISTE; sua imprecisão (não distinguir cenários que a própria prosa
		declara — 'requisitante retira OU supervisor limpa'; 'originadora OU
		supplier-withdraw') é exatamente o recorte da def-080, não desta
		obrigação. O resíduo que permanece desta aparição é quem SUPERVISIONA
		os cancels marcados supervisedDecision — a forma da aparição do pool.

		Alternativas avaliadas para o predicado de classificação — o desenho
		difícil desta decisão, porque 'transição de exceção' não é classe
		declarada hoje: (a) CAMPO DE CLASSE na transição
		(transitionClass: happy-path | exception) — precisão total e
		expressável em tipo (P14), rejeitada AGORA pelo custo de retrofit em
		todos os domain-models (12+ BCs) para uma obrigação cujo alvo
		verificado está concentrado nas marcas de supervisão; reabre com o
		dado real se a cobertura por marcas se provar insuficiente. (c) LISTA
		CURADA com check de completude — rejeitada: a lista re-introduz o
		julgamento de leitura que a mecanização quer eliminar e apodrece em
		silêncio (o mesmo drift-por-prosa que o stakeholder-map acabou de
		exibir com números de passo). Escolhida (b-restrita): predicado
		DERIVADO DE MARCAS JÁ DECLARADAS — onde o autor já declarou
		supervisão ou escalação, a obrigação morde; sem julgamento de
		fronteira, porque não há inferência: há marca.
		"""

	decision: """
		(1) OBRIGAÇÃO: toda exceção DECLARADA nomeia quem responde. Norma
		para o modelo vigente e MOLDE para modelagem futura: cancelamento
		pós-CMT, resposta à proposta órfã, terminação e reabertura — quando
		o founder os modelar — nascem com destinatário declarado.

		(2) CLASSIFICAÇÃO por marcas declaradas, sem campo de classe novo:
		a obrigação incide sobre (i) toda #EscalationRoute
		(escalationRouting/categoryDefaults dos envelopes de governança) e
		(ii) toda supervisedDecision declarada (governanceScope dos canvases
		e comandos marcados supervisedDecision per bd-*). Onde há marca, há
		obrigação; transição sem marca fica fora até que a opção (a) reabra
		com dado de cobertura real.

		(3) CAMPO DE RESPOSTA: rota nomeada resolvendo sob o vocabulário de
		ator do adr-182 (roleRef preferencial; kind/actorId quando concreto)
		— nunca enum paralelo. FORMA PLACEHOLDER DECLARADA: uma rota pode
		resolver para placeholder Phase 0 (hoje, founder) DESDE QUE marcada
		como placeholder — visível e contável, nunca string solta. É a
		acomodação que dissolve a tensão Phase 0: o placeholder deixa de ser
		silêncio e vira dívida declarada.

		(4) MECANIZAÇÃO como fatia própria (WI), não este ADR: extensão de
		schema (tipar #EscalationRoute.recipient e o decider da
		supervisedDecision sob adr-182 + a forma placeholder) + structural
		check novo, nascendo born-warn per adr-097 (a catraca do repo), com
		critério de promoção declarado: promove a reject quando o retrofit
		das rotas existentes estiver completo e o dd-gate de placeholders
		(falsificação abaixo) estiver reportando.

		(5) POSTURA TRANSITÓRIA até a fatia: as aparições atuais permanecem
		terminais pendentes DECLARADOS, como o wireflow do protótipo já
		marca; nenhuma modelagem de cancelamento, suspensão, terminação ou
		reabertura é decidida aqui — a ordem dessas decisões é do founder,
		com este molde na main.
		"""

	consequences: """
		Positivas — P1: o placeholder Phase 0 deixa de ser indistinguível de
		destinatário real: vira forma declarada, contável e auditável — a
		dívida aparece em relatório em vez de passar por resolvida. P2: a
		modelagem futura das exceções relatadas (órfã, terminação,
		reabertura) nasce sob molde, não sob improviso — o padrão que gerou
		cinco aparições em três superfícies não gera a sexta. P3: o check
		deriva de marcas declaradas (P12): zero julgamento de leitura no
		gate, consistente com P10 e com o desenho do adr-175 (o catálogo do
		gate são declarações, não inferências). P4: vocabulário único de
		ator (adr-182) atravessa comando, envelope e rota — sem enum
		paralelo.

		Negativas — N1: cobertura parcial por construção: transição de
		exceção SEM marca declarada fica fora do gate até a opção (a)
		reabrir — o custo aceito de não retrofitar 12+ BCs agora. N2: custo
		da fatia: extensão de 2 schemas, retrofit das rotas existentes
		(~6 rotas no envelope do ssc; envelopes dos demais BCs a contar na
		fatia), check novo + fixture. N3: a obrigação NÃO cria as respostas
		ausentes — proposta órfã, terminação e reabertura continuam não
		modeladas até decisão do founder; o ADR só garante que nasçam com
		dono. N4: born-warn até a promoção: o gate não segura erro novo no
		intervalo (mitigado pela disciplina de autoria, como nos sc-ds).
		"""

	falsificationCondition: {
		condition:        "Rotas de exceção declaradas permanecerem resolvendo apenas para a forma placeholder após as fatias que deveriam consumi-las — a obrigação virou carimbo: destino declarado que nunca vira destino real."
		observableSignal: "Contagem de #EscalationRoute com marca placeholder vs resolvida, reportada pelo structural check da fatia; placeholder count não-decrescente por 3 fatias consecutivas que toquem os BCs afetados."
	}

	affectedArtifacts: [
		"architecture/artifact-schemas/agent-governance.cue",
		"architecture/artifact-schemas/canvas.cue",
		"contexts/ssc/agents/ssc-primary-agent.governance.cue",
	]

	principlesApplied: [
		"P10 — o gate novo varre marcas declaradas deterministicamente; o julgamento (quem DEVE responder) permanece decisão humana na autoria, nunca no check.",
		"P12 — quem responde à exceção vira contrato declarado e verificável, em vez de conhecimento em memória ou prosa de placeholder.",
	]

	rationale: """
		A pergunta única por trás das aparições — 'toda transição de exceção
		declara quem responde?' — só vale como regra se for machine-evaluable,
		e o desenho honesto encontrado no disco é que as exceções JÁ SE
		DECLARAM onde importa hoje: nas rotas de escalação e nas
		supervisedDecisions. Derivar a obrigação dessas marcas compra
		mecanização sem retrofit repo-wide e sem predicado que erra fronteira;
		o preço declarado (N1) é a cobertura parcial, reabrível com dado.
		FRONTEIRA COM A def-080, demonstrada na autoria: cancelledBy/decidedBy
		registram quem AGIU (passado, campo do comando — precisão é o recorte
		da def-080); respondedBy/rota declara quem DEVE AGIR quando o fluxo
		sai do feliz (futuro, campo da rota/supervisão). Campos distintos com
		vocabulário comum (adr-182): quando a def-080 mecanizar o ator do
		comando, os dois consomem o mesmo #Actor — dependência nos dois
		sentidos, sem colapso. Relação com adr-196: a proposta materializada
		é fato que uma rota de exceção pode referenciar (a resposta à
		proposta órfã, quando modelada, aponta o fato proposto — não um
		estado interno de agente). Reversibility high: norma + check warn,
		sem dado persistido nem contrato público; blastRadius cross-cutting:
		schemas de governança + envelopes de múltiplos BCs no retrofit da
		fatia.
		"""
}
