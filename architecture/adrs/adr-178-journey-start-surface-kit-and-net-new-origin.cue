package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr178: artifact_schemas.#ADR & {
	id:    "adr-178"
	title: "Kit de superfície do início da jornada (recorte p2p: submissão de requisição + fila de triagem) + 2ª família do codegen de frontend + o não-padrão de origem net-new instituído sobre o 'por padrão' da adr-150"
	date:  "2026-07-14"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		A ds-buyer-procurement-journey nasce no canteiro: o engenheiro, na
		visita técnica diária, identifica pelo cronograma físico o que as
		próximas etapas vão exigir, e formaliza a solicitação DIRETO DO
		CANTEIRO (passos 1-3). O domínio desses passos está pronto desde o
		WI-151/adr-174 (cmd-submit-purchase-requisition, agg-purchase-
		requisition, prj-pending-requisitions/qry-pending-requisitions) e foi
		endurecido pelo adr-177 (portão duplo). O que NÃO existia era a
		SUPERFÍCIE: o p2p não tinha api.yaml (o canvas declara
		hasSyncSurface: true sem o arquivo — warn sc-cv-02 vivo no baseline),
		nem schemas/, nem manifests — nada que os geradores consomem.

		A cadeia-precedente é a da única tela existente (override FCE):
		spec (kit: api.yaml + schemas + aggregate-manifest + port-manifest,
		WI-140/143/144/146) → mesh-runtime (geração via discovery rtd-013 +
		dev serve) → frontend-runtime (contrato adr-158 + geração + tela).
		O founder decidiu construir as telas NA ORDEM DA JORNADA — começando
		pelo início (a submissão do canteiro + a fila de triagem), para que o
		dado seja real de ponta a ponta: a tela de submissão cria requisições
		de verdade → a fila tem o que mostrar → o sourcing tem o que cotar →
		o mapa de cotações (3ª família) compara cotações que existem.

		A QUESTÃO NORMATIVA. A tela de submissão é a primeira tela de ESCRITA
		DE ORIGEM HUMANA da Mesh, e a lei adr-150 diz — verbatim, decisão
		(1): "agentes operam, humanos entram por excecao; nao e o locus
		primario de operacao humana"; e decisão (2b): "Generative Form --
		formularios pre-preenchidos pelo agente, com o humano
		confirmando/editando, nunca digitando do zero por padrao". A lei NÃO
		contém cláusula de exceção para entrada de origem humana (verificado
		verbatim contra o arquivo nesta fatia; a formulação anterior desta
		decisão atribuía à lei um 'braço net-new' que ela não tem — corrigida
		pelo founder ANTES da escrita: este ADR institui, não cita). Os
		únicos qualificadores reais do texto são 'por padrao' (a Generative
		Form declara-se regra-default, não absoluto) e 'locus primario'
		(primazia, não proibição).

		Alternativas consideradas:
		(a) Tratar a tela de submissão como violação/tensão da adr-150 e
		    registrar tension-entry. REJEITADA: a lei qualifica-se a si mesma
		    ('por padrao'); o caso não contradiz o texto — ocupa o não-padrão
		    que o texto deixa em aberto sem definir. Tensão registraria
		    conflito onde há lacuna de definição.
		(b) Emendar a adr-150 para conter a exceção. REJEITADA: ADRs accepted
		    são snapshots; supersessão parcial é cerimônia pesada para
		    definir um não-padrão que o qualificador já comporta.
		(c) Adiar a tela até existir agente-preenchedor (Generative Form
		    plena). REJEITADA: o preenchedor exigiria o cronograma DENTRO do
		    sistema — que é exatamente a informação que hoje só existe na
		    observação humana. Esperar inverte a ordem: a informação entra no
		    sistema PELA tela; o agente entra quando a fonte virar input
		    (def-081).
		(d) Instituir o não-padrão NESTE ADR, ancorado no qualificador real
		    da lei, com critério estreito e migração registrada. ESCOLHIDA.

		Mecânica (Tempo 1 + eco verbatim da lei): kit espelha o FCE; o
		contrato de codegen do frontend era explicitamente FCE-scoped (V1) —
		a 2ª família exige extensão; o próprio contrato previa, verbatim:
		"Promoção a schema só se >1 família de frontend o exigir".
		"""

	decision: """
		(1) KIT DE SUPERFÍCIE DO RECORTE (contexts/p2p/): api.yaml (convenção
		adr-048; postura def-024 sem security/servers) com EXATAMENTE 2
		paths — GET /v1/p2p/queries/pending-requisitions (implementa a
		qry-pending-requisitions; envelope {items}; fila vazia = 200; filtros
		opcionais status/costCenterRef/categoryRef/requestedBy) e POST
		/v1/p2p/commands/submit-purchase-requisition (Idempotency-Key; 200
		devolve o evento PurchaseRequisitionSubmitted como confirmação, molde
		CMT/FCE; SEM 409/422 por design — a submissão não tem guard de
		domínio na porta: a completude é verificada na TRIAGEM, que DEVOLVE
		com outcome=returned, espelhando o setor de compras real). O POST da
		triagem fica FORA (fatia da tela 2); async-api.yaml FORA (precedente
		WI-149 — autora com gatilho browser-live; o warn sc-cv-03 permanece).

		(2) KIT DE RUNTIME PARCIAL (precedente FCE/WI-140): schemas/events.cue
		(os 6 eventos da requisição como #Envelope sobre shared-schemas;
		#PurchaseRequisitionState fechado espelhando lifecycle.states;
		reasonCode fechado com fidelidade — o domain-model fecha via
		constraint; outcome da triagem ABERTO — o domínio não o fecha, nota
		P14 transparente); aggregate-manifests/am-purchase-requisition.cue
		(5 commands + 6 events + 3 invariants VERBATIM do domain-model,
		zero-drift verificado programaticamente no checkpoint);
		port-manifest.cue (pm-p2p: EventLogPort append/readStream, grafia
		canônica rtd-004; as interações sync do portão duplo são canvas
		query-surfaces per adr-055, não Ports). Com o kit, o discovery do
		mesh-runtime (rtd-013) passa a pegar o p2p no próximo regenerate — o
		degrau runtime do arco de telas, sem ação daquele repo nesta fatia.

		CONSEQUÊNCIA DECLARADA DO MANIFEST (sc-fct-01, adr-151/adr-153): a
		criação do am-purchase-requisition traz os 12 conceitos do recorte
		(1 agg + 5 commands + 6 events) para DENTRO do gate first-class-
		traceability (reject) — o p2p não passou pelas 4 ondas da campanha
		de backfill Forma A porque não tinha manifest. Os 12 ENTRAM NA
		WORKLIST de backfill como pendência RECONHECIDA (o mecanismo que o
		adr-151 desenhou — falsificação 4: pendente-reconhecido ≠
		verde-falso; o gate segue reject e visível). A DRENAGEM é a ONDA
		P2P: 5ª onda da campanha, no molde das ondas cmt/dlv/fce/rew —
		fatia de higiene própria com as 12 decisões de Forma A
		(firstClass/reason/coreNoun + termos de glossary), que são
		modelagem de domínio e por isso NÃO são tomadas nesta fatia de
		superfície. A worklist volta de vazia para 12 entries
		CONSCIENTEMENTE — declarado aqui para nunca parecer retrocesso
		silencioso (uq-05).

		(3) 2ª FAMÍLIA DO CODEGEN DE FRONTEND: frontend-codegen-contract.cue
		estendido IN-PLACE para v2 (+p2pSurface: cmd-submit + 3 VOs +
		evento-confirmação + enum completo do lifecycle; +3 transform stages
		da família 2). A view da fila segue o REGIME DA 1ª FAMÍLIA (espelho
		hand não-contrato no frontend, precedente escalated-queue.ts). A
		PROMOÇÃO A SCHEMA first-class é ESPERADA e NOMEADA para a 3ª família
		(o mapa de cotações do ssc) — decisão prevista, não surpresa.

		(4) O NÃO-PADRÃO DE ORIGEM NET-NEW — decisão normativa DESTE ADR (o
		ADR institui; NÃO é leitura implícita da adr-150). A adr-150 diz,
		verbatim: "Generative Form -- formularios pre-preenchidos pelo
		agente, com o humano confirmando/editando, nunca digitando do zero
		por padrao". ESTE ADR INSTITUI o que ocupa o não-padrão que o 'por
		padrao' deixa em aberto: ORIGEM NET-NEW — o form pode nascer de
		digitação humana QUANDO E APENAS QUANDO a informação não existe no
		sistema até o ato da observação humana. O caso desta fatia satisfaz o
		critério: o cronograma físico do canteiro, na visita técnica do
		engenheiro, não é lido de nenhum estado do sistema — a informação
		ENTRA no sistema por este ato. A DISTINÇÃO É DURA: origem net-new
		(fonte fora do sistema — legítima) ≠ digitação-do-zero-por-preguiça
		(a informação EXISTE no sistema e o form não a pré-preenche —
		proibida pelo padrão da lei; toda tela futura que invocar este
		não-padrão deve demonstrar que a fonte está fora do sistema, e o
		critério morre para o caso quando a fonte entrar — def-081). O SHAPE
		da superfície segue a lei integralmente: form pré-preenchível campo a
		campo (Generative Form por construção), Action-as-Tool, confirmação
		estruturada devolvendo o evento; a submissão NÃO é ação financeira —
		Approval-as-Confirmation não é acionada. MOLDE adr-155: aquele ADR
		citou P10/P11 pelo texto real e mostrou que o override os CUMPRE;
		este cita o 'por padrao' real e INSTITUI o não-padrão, mostrando que
		a submissão é o caso legítimo.

		(5) MIGRAÇÃO REGISTRADA (def-081): quando o cronograma físico virar
		input de sistema (BIM/planejamento da obra lido por agente), a origem
		da requisição SAI do não-padrão net-new e ENTRA na Generative Form
		padrão da adr-150 (form pré-preenchido pelo agente; engenheiro
		confirma/edita) — sem mudança de shape na superfície. status open,
		trigger manual-review.

		(6) TESTE DE SUFICIÊNCIA DA 2ª FAMÍLIA (molde adr-157 item 8): a
		sessão do frontend-runtime que construir a tela do início da jornada
		lê ESTE ADR + adr-150 + adr-158/contrato v2 + contexts/p2p/
		{domain-model.cue, api.yaml, schemas/events.cue} — e NÃO re-pergunta
		o que aqui está decidido (recorte, origem net-new, regime da view,
		ausência de auth per def-024). Se a 1ª sessão da tela precisar
		re-perguntar uma decisão que este conjunto deveria conter, este ADR
		falhou o teste (cláusula anti-inferência herdada do adr-157).

		(7) VEÍCULO: sem WI, sem work-event (padrão adr-176/adr-177) — a
		materialização ocorre integralmente nesta fatia. A catraca
		agente↔modelo NÃO move: nenhum id das 6 famílias operáveis nasce
		(superfície, não domínio); sc-ag-01/02/03 permanecem verdes por
		construção. O warn sc-cv-02 do p2p (hasSyncSurface true sem api.yaml)
		é QUITADO pela criação do arquivo. Runner pós-fatia: 30 warns / 0
		bloqueantes (31 do baseline − 1 sc-cv-02 quitado; os 12 conceitos do
		sc-fct-01 reconhecidos na worklist per decisão (2), não silenciados).
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE (a) o não-padrão net-new virar brecha — telas de origem futuras invocando-o para informação que JÁ existe no sistema (digitação-por-preguiça vestida de origem), OU o critério nunca migrar (def-081-class transitions não disparando enquanto telas de origem multiplicam); OU (b) o kit parcial quebrar o discovery do mesh-runtime (regenerate falhando sobre BC com manifest de 1 aggregate e schemas de 6 eventos — o precedente FCE diz que não); OU (c) a extensão in-place do contrato não sobreviver à 2ª família na prática (o gerador do frontend precisar de decisão estrutural que só a promoção a schema daria — nesse caso a promoção antecipa, não espera a 3ª)."
		observableSignal: "Sinal (a): PR futuro de tela de origem cujo ADR/prosa invoque net-new sem demonstrar fonte-fora-do-sistema — visível em review; def-081 parado em open com telas de origem acumulando. Sinal (b): regenerate do mesh-runtime falhando no discovery do p2p — visível no CI daquele repo no próximo bump. Sinal (c): a fatia frontend da 2ª família escalando decisão de contrato que o v2 não contém (a cláusula anti-inferência do item 6 a torna visível como falha DESTE ADR)."
	}

	consequences: """
		Positivas:
		(P1) O arco de telas do início da jornada fica destravado nos 3
		degraus com UMA fatia de spec: superfície declarada (api.yaml),
		geração runtime habilitada (kit + discovery rtd-013), contrato de
		frontend estendido (v2). Os degraus 2-3 são fatias dos outros repos,
		com contrato pronto.

		(P2) A 1ª tela de escrita de origem humana nasce com posição
		normativa PRECISA: não é exceção pedida, não é violação tolerada — é
		o não-padrão que o 'por padrao' da lei comporta, com critério duro
		(fonte fora do sistema) e migração registrada (def-081). O precedente
		que as próximas telas de origem citarão exige demonstração, não
		alegação.

		(P3) O warn sc-cv-02 do p2p (superfície declarada sem arquivo desde o
		bootstrap do BC) morre — baseline 31→30. A promessa vazia do canvas
		vira contrato materializado.

		(P4) Dado real de ponta a ponta: construindo as telas na ordem da
		jornada, a submissão alimenta a fila, a fila alimenta o sourcing, e a
		3ª família (mapa) nasce comparando cotações reais — zero fixture,
		coerente com a regra do frontend (erro honesto, nunca dado inventado).

		Negativas:
		(N1) Superfície sem servidor: o api.yaml existe antes de o
		mesh-runtime gerar o p2p e servir os 2 paths (fatia daquele repo,
		padrão rtd-032/033). Janela idêntica à do FCE entre WI-143/144/146 e
		o serve — fecha no próximo pacote-runtime.

		(N2) A fila de triagem não tem query-surface DECLARADA no canvas do
		p2p (o canvas declara 2 query-surfaces do PO; a qry-pending-
		requisitions vive no domain-model desde o WI-151). O api.yaml
		referencia a query capability do domain-model como identidade. A
		enumeração do canvas é lacuna de coevolução PRÉ-EXISTENTE (do WI-151,
		não desta fatia) — sinalizada ao founder no checkpoint desta fatia
		para decisão (tocar canvas é fora do escopo cravado).

		(N3) O não-padrão instituído aqui é um precedente PODEROSO — por isso
		a falsificação (a) o vigia especificamente, e o item 4 exige
		demonstração de fonte-fora-do-sistema em todo uso futuro. O custo de
		policiar é review de ADR/tela de origem, não gate determinístico
		(critério 'existe no sistema?' não é machine-evaluable hoje).

		(N4) A worklist de backfill do sc-fct-01 volta de VAZIA (4 ondas
		completas) para 12 entries — o custo consciente do manifest,
		declarado na decisão (2). O gate segue reject e as entries são a
		pendência RASTREADA pelo próprio evaluator até a onda p2p drenar.
		Vigiado: worklist parada com o arco de telas avançando é o sinal de
		retrocesso que a disciplina da campanha (adr-151/153) observa — a
		onda p2p deve preceder ou acompanhar a fatia da tela 2 (triagem),
		que tocará os mesmos conceitos.

		Fronteira regulatória: nenhuma nova. A postura def-024 (borda sem
		auth até o ADR de auth; atribuição nominal não-verificada) é apontada,
		não alterada. Nenhum dinheiro move por esta superfície (a submissão
		precede cobertura e emissão).
		"""

	affectedArtifacts: [
		"governance/build-time/frontend-codegen-contract.cue",
		"governance/build-time/first-class-backfill-worklist.cue",
	]

	plannedOutputs: [
		"contexts/p2p/api.yaml",
		"contexts/p2p/schemas/events.cue",
		"contexts/p2p/aggregate-manifests/am-purchase-requisition.cue",
		"contexts/p2p/port-manifest.cue",
		"architecture/deferred-decisions/def-081-requisition-origin-prefill-when-schedule-becomes-system-input.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	defersTo: ["def-081"]

	principlesApplied: [
		"P14/adr-146 — os schemas preservam as distinções compile-time do domínio: lifecycle fechado (o domínio fecha), reasonCode fechado (constraint fecha), outcome da triagem ABERTO (o domínio não fecha — o espelho não inventa tipo), decimal-como-string (Ion-4).",
		"P1 — a superfície de frontend/runtime é GERADA da spec (contrato v2 + kit); nada da superfície é escrito à mão nos runtimes além do declarado regime hand da view (herdado da 1ª família).",
		"P0 — o kit APONTA (verbatim com zero-drift verificado no manifest; x-mesh-cue-ref no api.yaml); a definição do não-padrão tem UMA localização (este ADR) e a lei permanece intocada no snapshot dela.",
		"adr-048/def-024 — convenção de api-spec e postura de borda sem auth aplicadas, não re-decididas.",
		"adr-055/adr-120 — as interações cross-BC do portão são canvas query-surfaces fora de Port e fora do grafo; o kit não cria aresta nem Port para elas.",
		"adr-150 — citada APENAS verbatim ('por padrao'; 'locus primario'); toda leitura além do verbatim é decisão deste ADR, na voz deste ADR (correção do founder sobre a formulação anterior, que atribuía à lei um braço que ela não contém).",
	]

	supersedes: []

	rationale: """
		Princípios aplicados: P14 (fidelidade de forma nos schemas), P1/P0
		(gerado-da-spec; ponteiros e verbatim), adr-048/def-024 (convenções
		de superfície), adr-055/adr-120 (acoplamentos do portão fora de
		Port/grafo).

		Failure mode evitado (o da formulação anterior da D5, corrigida pelo
		founder ANTES da escrita): atribuir à adr-150 um 'braço net-new' que
		o texto não contém — fabricação de citação em posição normativa,
		exatamente a classe de erro que os reviews isolados desta sessão
		mataram (lens fantasma no adr-123; ax-02 no adr-177). O mecanismo
		correto é INSTITUIR: o qualificador real ('por padrao') deixa o
		não-padrão em aberto; este ADR o define com critério duro e migração
		registrada. A lei não é editada nem parafraseada — é citada verbatim
		onde citada.

		Relacionamento com adr-155 (o molde): o override citou P10/P11 pelo
		texto real e mostrou que o comando CUMPRE cláusulas existentes. A
		submissão não tem cláusula existente que a preveja — por isso o verbo
		aqui é instituir, não cumprir; a simetria está na disciplina (só
		texto real entre aspas; o caso demonstrado contra o critério, não
		alegado).

		Relacionamento com a Story: fecha o lar de escrita da PONTA-CANTEIRO
		(passos 1-3 nasceram no WI-151 como domínio; ganham superfície aqui).
		O passo 1 (a observação no canteiro) permanece sem cerimônia própria
		POR DECISÃO (WI-151: fato-de-origem como campo budgetStageRef) — este
		ADR não o reabre; a tela materializa o ato de formalização 'direto do
		canteiro' do passo 2.

		Relacionamento com def-081: não é 'falta o agente' — é a transição de
		regime quando o PRESSUPOSTO do critério (cronograma fora do sistema)
		mudar. O trigger é manual-review porque 'cronograma virou input de
		sistema' é fato de produto/integração que só o founder observa; a
		âncora de revisita vive no ponto de uso (action-surface-p2p do
		contrato v2 e o POST do api.yaml citam def-081).

		Relacionamento com a 3ª família (mapa de cotações): a promoção do
		contrato a schema first-class fica NOMEADA como gatilho dela — o
		founder decidiu prever a decisão em vez de deixá-la surpreender; a
		view-de-query entrar no codegen é parte da mesma revisita.

		Tensão com axiomas: nenhuma. A premissa AI-first da adr-150 decisão 1
		(verbatim: a interface "nao e o locus primario de operacao humana")
		permanece verdadeira NO AGREGADO — leitura deste ADR: a tela de
		origem é o ponto onde informação nasce para o sistema operar; quanto
		mais o sistema opera, mais def-081-class migrações movem origem para
		agentes.

		Lenses consultadas: nenhuma com match direto — decisão resolvida por
		princípios + precedentes internos (adr-155 molde de posicionamento
		perante lei; adr-157 molde de handoff/suficiência; FCE/WI-140-146
		molde de kit), mesmo regime do adr-174/adr-177.
		"""
}
