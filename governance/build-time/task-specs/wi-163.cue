package task_specs

taskSpecs: "WI-163": {
	version:     1
	title:       "Fechar o elo pedido↔compromisso no cmt: o agg-commitment passa a reter o purchaseOrderRef que hoje só existe no evento de entrada do ACL — e o bdg registra a reversão da decisão D1 que dependia dele sem que ele existisse"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"O DEFEITO, verificado em 2026-09-18: o rationale de evt-commitment-accepted-received no bdg (contexts/bdg/domain-model.cue) afirma que 'o aggregate do cmt guarda purchaseOrderRef' e constrói sobre isso a cadeia de enriquecimento commitment → purchaseOrderRef → requisitionRef. O agg-commitment NÃO guarda: seus fields são parties, contractTermsRef, currentState, scope, createdAt, updatedAt. É código de integração declarado sobre premissa que o modelo não sustenta.",
		"NÃO HÁ CAMINHO ALTERNATIVO — os quatro lugares onde o elo poderia estar foram verificados: agg-commitment (não tem), agg-purchase-order no p2p (não tem; commitmentId/commitmentRef dá zero ocorrências em todo o domain-model), evt-commitment-accepted (payload é commitmentId + parties + contractTermsRef + scope + acceptedAt + termsHash + confirmedBy, no domain-model e no envelope de wire) e evt-purchase-order-received (TEM — e é o único). O elo existe só no evento de entrada, que o cmt consome e descarta. Lookup reverso é impossível porque o p2p nunca fica sabendo qual compromisso nasceu do seu pedido.",
		"CARDINALIDADE — referência SIMPLES, não lista. Quatro evidências convergentes: (1) pol-purchase-order-initiates-commitment dispara por evt-purchase-order-received e emite UM cmd-propose-commitment, sem mecanismo de agregação; (2) vo-commitment-scope é escalar (description, value, end), sem lista de pedidos; (3) contexts/cmt/canvas.cue declara a premissa 'Mapeamento 1:1 entre compromisso e CommitmentId é suficiente — não há necessidade de hierarquia de compromissos (master/sub)', e master/sub é exatamente a forma que um compromisso cobrindo vários pedidos exigiria; (4) o glossário do cmt declara multiplicidade na direção OPOSTA ('Um contrato pode gerar múltiplos compromissos').",
		"RESSALVA DA CARDINALIDADE, registrada para não virar restrição silenciosa: a evidência (3) é um campo `assumption` no canvas, NÃO invariante. É o artefato que teria de mudar PRIMEIRO se um dia um compromisso precisar cobrir mais de um pedido. Referência simples é a leitura correta do disco hoje; descobrir depois que ela virou restrição sem ninguém ter decidido é o custo que este registro evita.",
		"O REF PRECISA VIAJAR NO EVENTO DE CRIAÇÃO, não só no de aceite: o agregado é reconstruído do próprio stream, e evt-commitment-proposed hoje carrega commitmentId + parties + contractTermsRef + scope. Sem o ref ali, o campo existiria e não sobreviveria ao replay — buraco pior que o original. Entram portanto cmd-propose-commitment e evt-commitment-proposed, além de evt-commitment-accepted.",
		"contexts/cmt/aggregate-manifests/am-commitment.cue — espelho zero-drift do agregado; o diff programático do checkpoint acusa divergência de commands/events/invariants.",
		"contexts/cmt/api.yaml + contexts/cmt/async-api.yaml — as duas superfícies existem no cmt; precedente adr-198, que lista contexts/ssc/api.yaml como afetado em mudança da mesma classe.",
		"A REVERSÃO DA D1 é parte da fatia, não efeito colateral: o bdg registra que 'cmt INTOCADO: a necessidade do bdg resolve na borda do bdg (D1 founder)'. A decisão é revertida porque foi verificada insatisfazível — a borda do bdg não tem de onde tirar o que precisa. O registro NÃO apaga a D1: declara que foi tomada, verificada insatisfazível e revertida, com o motivo. D1 não foi erro de julgamento — foi decisão razoável tomada sem conhecimento de que o elo não existia em lugar nenhum.",
		"contexts/cmt/agents/cmt-primary-agent.cue — a catraca sc-ag-02 (adr-175 born-warn; promovida a reject pelo adr-176) morde commands e events NOVOS. Esta fatia não cria nenhum: altera payloads de existentes. Cobertura presumida intacta, VERIFICADA na fatia — se o runner acusar, o agent-spec entra como output.",
		"O número WI-163 foi mantido por confirmação do arquiteto contra o STOP do G2: o gate deriva de origin/main e não enxerga o WI-162, que vive na branch claude/quirky-cray-3tkf9a com PR aberto. Renumerar para 162 criaria a colisão que o gate existe para evitar. Materialização na MESMA branch, mesmo PR.",
	]
	outputs: [{
		artifact: "contexts/cmt/domain-model.cue"
		type:     "update"
	}, {
		artifact: "contexts/cmt/schemas/events.cue"
		type:     "update"
	}, {
		artifact: "contexts/cmt/aggregate-manifests/am-commitment.cue"
		type:     "update"
	}, {
		artifact: "contexts/cmt/api.yaml"
		type:     "update"
	}, {
		artifact: "contexts/cmt/async-api.yaml"
		type:     "update"
	}, {
		artifact: "contexts/bdg/domain-model.cue"
		type:     "update"
	}]
	affects: [
		"contexts/cmt/agents/cmt-primary-agent.cue",
		"contexts/cmt/canvas.cue",
		"contexts/bdg/canvas.cue",
	]
	rationale: """
		O fio de rastreabilidade end-to-end é unidirecional: do compromisso
		para frente (bdg, dlv, inv, fce) ele funciona; de volta ao pedido está
		cortado. Foi essa ponta cortada que deixou o defeito passar
		despercebido — nenhum dos dois lados conseguia agir mesmo querendo, e
		por isso ninguém reclamou.

		A urgência não é o rationale errado em si: é o que ele sustenta. A
		cadeia de enriquecimento é o que permite ao bdg casar o
		CommitmentAccepted com a reserva certa (inv-confirmation-requires-
		active-reservation, keyed por requisitionRef). Implementado como está
		escrito, o ACL falha ao resolver a requisição, e a efetivação da
		reserva falha com ele — o mecanismo de que depende o desenho de
		reencaminhamento de linha, que anda de volta do compromisso ao pedido.

		Escopo deliberadamente mínimo: um campo, os três atos que o carregam
		(propose, proposed, accepted), os espelhos, e a reversão registrada.
		Nenhum estado novo, nenhuma transição nova, nenhum comando novo. O que
		este WI NÃO faz: não decide o que acontece com o pedido quando o
		fornecedor recusa o compromisso, não libera reserva, não cria o
		reencaminhamento. Fecha a pré-condição estrutural dos três.
		CLASSIFICAÇÃO: instanciação (sem ADR novo — precedente WI-161, que
		modelou a negociação inteira do ssc com comandos e eventos novos e
		foi classificado assim; aqui é menos: um campo em payloads
		existentes).
		"""
}
