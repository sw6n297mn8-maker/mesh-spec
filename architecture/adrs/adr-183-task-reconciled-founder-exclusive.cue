package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-183 -- Estabelece o eventType task-reconciled no motor de
// work-governance, sob direito de comando exclusivo do founder, para corrigir
// estado FALSO no log de work-events em regime de STEADY STATE. Distingue-se
// do backfill retroativo do adr-024 item (3), que foi instrumento de
// BOOTSTRAP e permanece válido para o que era. Motivado pela varredura de
// reconciliação de 2026-07-30, que provou WI-067, WI-069 e WI-151 concluídos
// com stream zero -- par (defined, none), sem caminho na máquina de estados.

adr183: artifact_schemas.#ADR & {
	id:    "adr-183"
	title: "Estabelecer o evento task-reconciled sob direito exclusivo do founder"

	date: "2026-08-01"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "repo-wide"

	context: """
		Estado precedente. O motor de work-governance
		(governance/build-time/work-governance.cue) é event-sourced sobre git:
		o estado de uma tarefa é derivação do stream, não campo. São DUAS
		máquinas -- admissionStateMachine (defined → proposed → approved |
		rejected) e executionStateMachine (unclaimed, claimed, blocked,
		completed, cancelled, superseded) -- acopladas por validStatePairs. A
		única transição que chega em completed é claimed → completed via
		task-completed, e o único par válido com completed é
		(approved, completed). Sobre isso repousa a premissa operacional do
		regime: a ready-queue é DERIVÁVEL das fontes.

		O que o repo já fez com trabalho pré-existente. O adr-024 ativou a
		Phase 1 da governança de trabalho e, no decision item (3), decidiu
		"work-events/ -- diretório de streams + backfill retroativo de tarefas
		já concluídas com timestamps extraídos do git log", aceitando na
		consequência que "backfill retroativo usa timestamps aproximados do
		git log (aceitável porque o objetivo é rastreabilidade, não precisão
		de relógio)". 51 streams carregam commandId sufixado -backfill;
		wi-001.cue traz task-approved com actor "founder" e commandId
		"WI-001-approve-backfill". Fabricar cadeia de aprovação retroativa é
		prática sancionada neste repo -- e legítima para o que era: dar
		passado a um log que estava nascendo.

		Trigger. A varredura de reconciliação de 2026-07-30 sobre os 26 WIs
		abertos/órfãos provou WI-067, WI-069 e WI-151 concluídos, com stream
		ZERO -- par (defined, none), que validStatePairs descreve como
		"TaskSpec existe, sem atividade no backlog". O método de prova NÃO foi
		uniforme: WI-067 e WI-151 têm outputs declarados e foram conferidos no
		disco item a item; WI-069 declara outputs: [] em sua task-spec, e a
		prova é o artefato que seu critério de done nomeia -- a entry disp-001
		em governance/build-time/subagent-execution-log.cue. Essa assimetria é
		o que o dec 6 codifica. O WI-043 tinha claim e foi fechado (PR #225).
		Os três não têm caminho: de (defined, none) a completed não existe
		transição nem par válido.

		Alternativas avaliadas:
		(a) Registro FORA do event log -- artefato de "concluído fora do fluxo"
		que a derivação da ready-queue consulta além do stream. Rejeitada:
		parte o estado do trabalho em duas casas; quem pergunta "qual o estado
		do WI-067?" passa a precisar saber que há dois lugares para olhar, e
		cada consumidor futuro da fila herda a segunda consulta. Violação
		direta de P0 -- o custo cresce com o número de consumidores.
		(b) Estender o backfill do adr-024 ao caso atual -- emitir
		task-proposed/task-approved/task-claimed/task-completed com commandId
		sufixado -backfill, exatamente como nos 51 streams existentes.
		Rejeitada: é o precedente mais próximo e o mais tentador, e é o que a
		distinção bootstrap-vs-steady-state do rationale recusa. O motivo NÃO é
		indistinguibilidade -- o sufixo -backfill é marcador explícito, e
		work-events/_constraints.cue o declara "para rastreabilidade"; eventos
		de backfill SÃO distinguíveis dos verdadeiros. O motivo é semântico:
		emitir task-approved com actor "founder" AFIRMA um ato de aprovação que
		não ocorreu, e apaga o fato relevante -- a falha de processo, o stream
		nunca aberto. O backfill mente sobre o quê aconteceu para preservar a
		forma da cadeia; task-reconciled preserva a verdade e abre mão da forma.
		(c) Relaxar a máquina para aceitar task-completed de qualquer origem.
		Rejeitada: apaga a diferença entre "concluído pelo fluxo" e
		"reconciliado", tornando o bypass invisível e o sinal de falsificação
		desta decisão indisponível.
		(d) Não fazer nada -- aceitar o estado falso. Rejeitada: o regime declara
		que o estado de uma tarefa é derivação do stream, e não campo. Deixar
		três streams derivando (defined, none) sobre trabalho concluído e
		verificado torna a derivação FALSA -- não indisponível, o que seria
		tolerável, mas errada, que não é. Precisão: a ready-queue permanece
		derivável nos dois cenários; o que estava falso é o estado derivado do
		work-item, não a derivabilidade da fila.
		"""

	decision: """
		(1) ESTABELECER o eventType task-reconciled como transição para
		completed sobre #ExecutionStateOrNone -- o tipo que já existe em
		work-governance.cue e que admite "none" ao lado dos estados de
		execução. Origem: qualquer estado de execução não-terminal (unclaimed,
		claimed, blocked) OU a ausência de estado (none), que é onde vivem os
		WIs de stream zero. RESTRIÇÃO POR ADMISSÃO: a transição só é válida
		quando admission ∈ {defined, approved}. Fica excluído rejected --
		reconciliar não move a admissão (dec 3), logo não pode partir de uma
		admissão que já negou a tarefa; e fica excluído proposed, cujo par com
		completed cobriria caso inexistente. NOTA DE ESCOPO: o ev-02 NÃO precisa
		de extensão -- seu algoritmo já parte do estado inicial (defined, none)
		e valida apenas que (fromState, trigger) → toState existe em
		transitions[], sem consultar executionStateMachine.states. Adicionada a
		transição, o ev-02 a valida sem alteração. E executionStateMachine.states
		também NÃO precisa de ajuste: #ExecutionStateOrNone já existe,
		validStatePairs já carrega execution: "none" em dois pares sem que
		states o enumere, e #StateTransition.from é string sem constraint --
		adicionar "none" a states é que criaria divergência com #ExecutionState
		e finalStates. Contagem completa do crescimento em N4.

		(2) ADICIONAR o par (admission: "defined", execution: "completed") a
		validStatePairs, com rationale que nomeia o que ele é: tarefa concluída
		SEM JAMAIS TER SIDO ADMITIDA. O par é a consequência N2 tornada
		estrutural -- quem lê validStatePairs vê que conclusão-sem-admissão
		existe, em vez de a exceção ficar escondida dentro do evento.

		(3) NÃO ALTERAR a máquina de admissão. task-reconciled não emite, não
		implica e não sintetiza task-approved. A admissão permanece onde está
		-- defined, para os três WIs. É ESTE ITEM que separa o mecanismo do
		backfill: o backfill movia a admissão fabricando o ato; este a deixa
		intocada e registra que ela não ocorreu.

		(4) MATERIALIZAR #TaskReconciledEvent como tipo concreto na união
		fechada #WorkEvent de work-governance.cue, portando o bloco de
		evidência do item (6). Sem tipo concreto o evento não passa em cue vet
		nem no check ev-01.

		(5) ESTABELECER o command ReconcileTask com direito EXCLUSIVO do
		founder: adicionar à união #CommandType, e declarar #CommandRight com
		allowedRoles ["founder"] e decisionClass "decide" -- mesma classe de
		ApproveTask. O spec-writer não detém o direito.

		(5b) ESTENDER #EffectClass com o sétimo valor "reconciliation", e
		atribuí-lo ao ReconcileTask. Rationale do valor novo, que declara o que
		ele É e o que NÃO é: conclusão DECLARADA RETROSPECTIVAMENTE -- sem
		admissão registrada (rota R1, os WIs de stream zero) OU sem o caminho
		de execução FECHADO POR PROVA CONTEMPORÂNEA (rota R2, admissão approved
		cuja cadeia claim→complete não se fechou com o #CompletionValidation da
		época -- forma do WI-043, cujo stream TEM task-claimed registrado; o que
		faltava era a prova, não o registro) -- com evidência APRESENTADA mas NÃO
		VERIFICADA por gate. As duas rotas, porque ReconcileTask é o command de
		ambas: rationale que cobrisse só R1 nasceria falso para metade do
		próprio alcance. O
		contraste com evidence_gated é o ponto -- aquele valor promete
		"conclusão validada por prova determinística", e a prova exigida pelo
		dec 6 mistura conferência de disco (determinística) com avaliação de
		escopo (juízo humano que nenhum gate valida, per N6). Reusar
		evidence_gated importaria promessa de determinismo que este ADR nega em
		N1 e N6 -- a mesma auto-refutação que o carve-out condicional do dec 7
		existe para evitar. Os demais seis valores estão descartados: admission
		contradiria o dec 3; destructive descreve destruição de trabalho aceito,
		e reconciliar declara em vez de destruir; allocation, execution_signal e
		topology_mutating não alcançam completed.

		(6) EXIGIR evidência no próprio evento, NESTA ORDEM: (a) avaliação de
		escopo da task-spec, em taxonomia TERNÁRIA -- exaustivo-nominal
		(outputs nomeados), fan-out (path template ou descoberta de autoria) ou
		SEM-OUTPUTS-DECLARADOS (outputs: [] na task-spec); (b) só então a
		prova, cuja forma É DETERMINADA pelo escopo apurado em (a):
		exaustivo-nominal exige path e resultado da conferência para cada
		output declarado; fan-out exige adicionalmente a cobertura medida
		contra o universo declarado; sem-outputs-declarados exige o artefato
		que o critério de done da task-spec nomeia -- em qualquer dos três
		casos, mais o tree hash da verificação; (c) declaração explícita do que
		a evidência NÃO prova -- presença e substância sim, data de conclusão e
		gates da época não. O escopo precede a prova porque determina a forma
		dela: arquivo com o nome certo não é prova sob fan-out (foi o que
		separou o WI-043 do WI-140 na varredura de 2026-07-30), e sob
		sem-outputs-declarados não há arquivo a conferir (é o caso do WI-069,
		cuja prova é a entry disp-001 do subagent-execution-log.cue). Taxonomia
		binária deixaria um dos três WIs motivadores sem regime probatório.

		(7) DECLARAR exceção CONDICIONAL ao ev-06 em event-validation.cue. A
		regra "eventos de execução só após admission approved" passa a admitir
		task-reconciled SSE admissionState computado ∈ {defined, approved} --
		predicado no corpo da exceção, não carve-out incondicional. É o único
		lugar do motor onde a restrição do dec 1 pode morar: #StateTransition
		tem apenas {from, to, trigger, rationale} e não comporta dimensão de
		admissão, e validStatePairs é declarativo. E ADICIONAR o mapeamento
		task-reconciled → ReconcileTask, para que a validação de autoridade
		(ev-03) alcance o direito exclusivo do item (5).

		ESTATUTO DESTE ITEM, declarado sem eufemismo: é DECLARAÇÃO NORMATIVA,
		não gate em execução. O ev-06 e o ev-03 têm enforcement "procedural" e
		NENHUM runner os executa (per N1). O que este item entrega é a regra
		escrita no lugar canônico onde um fiscal futuro a encontra -- não a
		verificação ativa. A construção do fiscal é PENDÊNCIA NOMEADA da fatia
		de saneamento do motor de work-governance, REGISTRADA COMO def-083
		(architecture/deferred-decisions/) com os onze achados do levantamento de
		2026-08-01, os itens que ESTA decisão lhe delega, e triggers
		codificados -- adjacent-need sobre o cabeamento do fiscal (no workflow
		e no structural-check) mais temporal de 90 dias como rede. "Nomeada"
		aqui significa artefato com id no disco e sensor vivo no runner, não
		intenção em prosa. Este ADR NÃO decide onde o fiscal mora
		(runner de ev-* vs structural-check) -- essa escolha exige o mapa
		inteiro do motor e pertence àquela fatia.

		(8) MANTER task-reconciled permanentemente DISTINTO de task-completed.
		Não é alias: a distinção é a condição de possibilidade do sinal
		observável de falsificação desta decisão.
		"""

	consequences: """
		Positivas:
		(P1) A FONTE PODE parar de mentir -- e a condicional é literal. Este ADR
		entrega a POSSIBILIDADE, não a aplicação: os streams de WI-067, WI-069
		e WI-151 não existem, e criá-los é ato do founder, um a um, fora desta
		decisão (por isso plannedOutputs fica omitido). QUANDO o mecanismo for
		aplicado, esses streams deixam de estar ausentes -- "nunca proposto,
		nunca feito" sobre trabalho concluído e verificado -- e passam a portar
		o fato correto com a prova anexa, de modo que qualquer derivação FUTURA
		que os leia encontre o estado certo. O ganho é no stream, nunca em
		projeção. Três precisões, todas verificadas no disco em 2026-08-01,
		para que a consequência não prometa o que não cumpre:
		(a) os três NÃO entram na ready-queue -- o readyQueueAlgorithm filtra
		admission=approved E execution=unclaimed, e o dec 3 mantém a admissão
		em defined;
		(b) as projeções materializadas NÃO passam a ficar corretas por isso --
		projections/ready-queue.cue não é recomputada desde 3351afb
		(2026-06-21, o squash do baseline), lista o WI-043 como ready, e
		in-progress.cue declara zero itens enquanto wi-140.cue carrega três
		claims sem release. O rebuild-projections.sh não roda em CI e sua
		taxonomia de admissão sequer produz "defined". Recomputar as projeções
		é trabalho da fatia de saneamento (def-083), não desta decisão;
		(c) o ganho de "destravar dependentes" NÃO se realiza para os três
		motivadores: nenhum aparece em work-graph.cue, e as task-specs de
		WI-067 e WI-069 declaram "Out-of-wave". O destravamento vale para
		reconciliações futuras de WIs que TENHAM dependentes no grafo.
		(P2) A anomalia fica ESTRUTURAL e legível. Quem lê validStatePairs vê
		que existe tarefa concluída sem jamais ter sido admitida -- não precisa
		abrir evento nem ler prosa. É a diferença entre exceção publicada e
		exceção escondida.
		(P3) O bypass fica CONTÁVEL: task-reconciled distinto de task-completed
		(dec 8) torna a razão entre os dois computável direto de
		governance/build-time/work-events/.
		(P4) A prova vira pré-condição de declarar feito, na ordem certa
		(dec 6): escopo → arquivos → limites. Falha observada e datada: na
		varredura de 2026-07-30 o agente classificou o WI-140 como concluído
		contando 6 manifestos; a apuração de escopo revelou fan-out incompleto
		(6 de 17 aggregates; 3 dos 4 do rew ausentes) e o WI foi mantido
		in-progress. A ordem do dec 6 existe por causa desse erro.
		(P5) O direito exclusivo do founder (dec 5) e a restrição por admissão
		(dec 1) ficam escritos no LUGAR CANÔNICO onde um fiscal os lê --
		predicado no ev-06 e mapeamento no ev-03 (dec 7) -- em vez de viverem
		como prosa de ADR. É ganho de posição, não de execução: per N1 nenhum
		runner roda os ev-*, e o dec 7 declara esse estatuto explicitamente. O
		valor real: quando a fatia de saneamento (def-083) construir o fiscal, a
		regra já estará onde ele procura, sem arqueologia em ADR.

		Negativas:
		(N1) ESTE MECANISMO NASCE EM MOTOR SEM FISCAL -- e esta é a consequência
		central, não uma ressalva de rodapé. Levantamento de 2026-08-01: o
		pipeline efetivo NÃO são as 7 regras de event-validation.cue -- aquele
		arquivo declara, na seção "Composição do pipeline efetivo", a união com
		claim-expiration-validation.cue (ev-08, ev-09, ev-10) e
		completion-gates.cue (ev-11). São ONZE regras ev-*, das quais DEZ têm
		enforcement declarado "procedural" e NENHUM runner as executa; só a
		ev-01 tem fiscal, via cue vet. O projection-drift.cue
		declara que "CI recalcula cada projeção e compara; drift > 0 → fail" e
		nenhum workflow o executa. O rebuild-projections.sh não tem modo
		--check e não é invocado por ninguém. O único structural-check sobre o
		motor, sc-wg-01, é pareamento de arquivo (existe task-spec para cada
		stream) e não olha conteúdo, estado nem autoridade. Prova viva em main:
		work-events/wi-140.cue carrega TRÊS task-claimed consecutivos sem
		task-released nem task-claim-expired -- violação direta do ev-05 que
		atravessou o CI. CONSEQUÊNCIA DIRETA para esta decisão: o predicado do
		dec 7 e o mapeamento do ev-03 são declarações normativas, não gates em
		execução; e qualquer leitor que suponha enforcement por vê-los escritos
		estará errado. A fatia de saneamento do motor -- def-083, com os onze
		achados enumerados e triggers codificados -- é quem constrói o fiscal.
		(N2) O mecanismo é BYPASS DE PORTÃO POR CONSTRUÇÃO, e isso é ESTRUTURAL.
		QUALIFICAÇÃO POR ROTA, porque o dec 1 admite duas e o efeito difere:
		na R1 -- (defined, none) → (defined, completed), os WIs de stream zero
		-- o portão contornado é o da ADMISSÃO, e a autorização não tem
		registro nenhum. Na R2 -- (approved, X) → (approved, completed), forma
		do WI-043 -- há task-approved no stream e a autorização TEM registro; o
		portão contornado é o do CAMINHO DE EXECUÇÃO (claim→complete), e o que
		falta é a prova contemporânea do #CompletionValidation -- exato para a
		origem (approved, claimed), a forma do WI-043; na origem (approved,
		unclaimed) falta também o REGISTRO do claim, não só a prova. As duas
		são bypass; de portões diferentes. O par (defined, completed) declara em validStatePairs que
		conclusão-sem-admissão é estado válido do sistema. O dec 3 garante que a
		admissão não seja fabricada -- o preço é que o log passa a conter,
		permanentemente, pares que dizem "nunca aprovado, concluído". Toda
		tarefa reconciliada é uma tarefa cuja autorização não tem registro, e
		nenhuma evidência de disco supre isso: a prova cobre que o TRABALHO
		EXISTE, nunca que FOI AUTORIZADO. A anomalia não é mitigada; é
		publicada.
		(N3) O par (defined, completed) é ABSORVENTE: nenhum evento sai dele. O
		task-reopened (completed → unclaimed) é evento de execução, e o
		carve-out do dec 7 cobre EXCLUSIVAMENTE task-reconciled -- com admissão
		em defined, o ev-06 o rejeitaria, e o par resultante (defined,
		unclaimed) não existe. O task-cancelled parte só de unclaimed/claimed/
		blocked; o task-superseded, só de unclaimed. Logo: reconciliação errada
		é INCORRIGÍVEL PELO MOTOR. Efeito colateral que este ADR precisa
		declarar: workGovernance.errorCorrection.compensatoryEvents afirma
		"Conclusão incorreta → task-reopened", sentença que se torna FALSA para
		o par novo -- mesma classe de refutação que o N4 (vi) captura para o
		validStatePairs.rationale. Assimetria a registrar: pela rota
		(approved, completed) o task-reopened segue válido; o buraco é
		específico do par que esta decisão cria.
		(N4) O motor cresce em QUINZE pontos. Em work-governance.cue: (i)
		task-reconciled na união #EventType; (ii) #TaskReconciledEvent como
		tipo concreto na união fechada #WorkEvent; (iii) o TIPO DO BLOCO DE
		EVIDÊNCIA do dec 6 -- união discriminada da taxonomia ternária mais os
		campos de prova, tree hash e declaração-do-que-não-prova, struct
		nomeada análoga ao #CompletionValidation e não campo solto; (iv)
		transições novas em executionStateMachine.transitions; (v) o par novo
		em validStatePairs; (vi) reescrita do validStatePairs.rationale, cujas
		DUAS sentenças ("Execution state só existe após admission atingir
		'proposed'" e "Execution só avança além de 'unclaimed' após admission
		atingir 'approved'") o dec 2 torna FALSAS; (vii) ReconcileTask na união
		#CommandType; (viii) entry de ReconcileTask em commandAuthority.rights,
		hoje exaustiva 11/11 sobre #CommandType; (ix) EXTENSÃO DE TAXONOMIA: o
		sétimo valor "reconciliation" em #EffectClass. Em command-rights.cue:
		(x) a entry #CommandRight de ReconcileTask. Em event-validation.cue:
		(xi) o predicado de admissão no corpo da exceção do ev-06; (xii) a
		atualização do algoritmo declarado do ev-06, hoje escrito como regra
		sem exceção; (xiii) o mapeamento task-reconciled → ReconcileTask. E de
		volta em work-governance.cue: (xiv) reescrita de
		errorCorrection.compensatoryEvents, que afirma "Conclusão incorreta →
		task-reopened" -- sentença que o par novo torna FALSA pelo mecanismo do
		N3, e que exige o mesmo tratamento que o item (vi) dá ao
		validStatePairs.rationale. Sem ela, esta decisão instalaria no artefato
		alvo a mesma classe de refutação que o item (vi) existe para evitar; e
		(xv) ressalva em taskCompletion, que hoje declara "Prova de validação
		obrigatória" com requires "completionValidation com validationRunId,
		artifactSnapshotHash, gatesPassed" -- requisito UNIVERSAL de conclusão
		que os dec 4 + dec 6 tornam parcial, já que passam a existir dois
		caminhos para completed e o segundo conclui sob bloco de evidência
		próprio, não sob #CompletionValidation. Terceira sentença normativa
		falsificada pela mesma decisão, ao lado de (vi) e (xiv) -- e a que este
		ADR mais tinha obrigação de ver, porque cita essa exata seção em
		principlesApplied como âncora de P10.
		NOTA DE CONTAGEM: executionStateMachine.states NÃO precisa de ajuste --
		#ExecutionStateOrNone já existe, validStatePairs já carrega
		execution: "none" em dois pares sem que states o enumere, e
		#StateTransition.from é string sem constraint. Adicionar "none" a
		states é que criaria divergência com #ExecutionState e finalStates.
		QUARTA SENTENÇA CANDIDATA, examinada e EXCLUÍDA com motivo -- porque
		uma contagem que se declara completa deve dizer o que deixou de fora.
		admissionStateMachine.rationale afirma "Requer aprovação explícita do
		founder antes de execução", e pela rota R1 uma tarefa alcança completed
		sem jamais ter admissão aprovada. Fica fora porque descreve o PROPÓSITO
		da camada de admissão, não o espaço de pares alcançáveis -- e o dec 3
		deixa aquela máquina literalmente intocada. Leitura disputável,
		registrada como tal: quem discordar tem o item (xvi) pronto.
		(N5) O regime probatório do dec 6 discrimina por ENUMERAÇÃO de outputs,
		nunca por #TaskOutput.type (create | update | validate). Para output de
		tipo "update", a prova exigida -- path e resultado da conferência -- é
		conferência de presença de arquivo que JÁ EXISTIA antes da tarefa, e
		portanto não prova nada sobre o delta. Não é hipótese: o WI-151, um dos
		três motivadores, declara exatamente um output e ele é
		{artifact: "contexts/p2p/domain-model.cue", type: "update"}. O item (c)
		do dec 6 afirma que a evidência prova "presença e substância" -- para
		outputs update, a substância conferida é a do arquivo inteiro, não a da
		mudança. Limitação declarada, não resolvida: discriminar a prova por
		#TaskOutput.type é refinamento futuro, e o WI-151 entra sob a ressalva.
		(N6) Superfície de erro do decisor único, ESTRUTURALMENTE SEM MITIGAÇÃO.
		O gate valida FORMA do bloco de evidência, não VERACIDADE da avaliação
		de escopo -- um fan-out mal classificado como exaustivo-nominal passa em
		todos os checks. E command-rights.cue declara o modelo single-emission,
		que "não suporta co-assinatura": o segundo par de olhos não está apenas
		ausente, está bloqueado por desenho hoje.
		(N7) A exceção ao ev-06 abre precedente: uma regra de validação passa a
		ter exceção nomeada. Cada exceção futura fica marginalmente mais fácil
		de justificar por analogia. Mitigação parcial: a exceção é nomeada,
		condicionada por predicado e única -- não é cláusula genérica de escape.
		(N8) Custo de autoria por reconciliação. Escopo + arquivos + limites,
		por WI. Reconciliar em lote fica caro POR DESENHO -- o atrito impede o
		mecanismo de virar atalho -- mas paga-se em cada uso.
		(N9) A razão do dec 8 é computável, mas NADA A COMPUTA. Nenhum decision
		item cria runner, projeção ou check que a meça. A leitura permanece ato
		deliberado -- diferente do padrão vigente para def-*, que tem
		scripts/ci/evaluate-deferred-triggers.sh e gate de carência. O sinal de
		falsificação existe e é derivável; a vigilância dele, não. Item nomeado
		na fila de saneamento do motor -- def-083, seção ITENS DELEGADOS, D1.
		NÃO é um dos onze achados: aquela enumeração é o mapa do disco, e este
		item nasce DESTA decisão. A proveniência está declarada lá, separada.
		"""

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se a reconciliação deixar de ser exceção
			e virar caminho ordinário de conclusão -- se o mecanismo passar a
			absorver trabalho que deveria ter atravessado o fluxo, tornando o
			portão de aprovação letra morta na prática. Nesse cenário N1 deixa
			de ser preço pontual de correção e vira o regime, e o par
			(defined, completed) deixa de ser anomalia publicada para virar
			estado comum.
			"""
		observableSignal: """
			Razão entre eventos task-reconciled e task-completed nos streams de
			governance/build-time/work-events/, por janela móvel. O sinal NÃO é
			a ocorrência: a primeira aplicação absorve o passivo conhecido de
			2026-07-30 (WI-067, WI-069, WI-151) e produz pico esperado. O sinal
			é a razão SUBINDO DE FORMA RECORRENTE em vez de retornar a ~0 após
			o pico. Computável direto do log porque dec 8 mantém os dois
			eventos permanentemente distintos. LIMITAÇÃO DECLARADA (N9):
			nenhum runner computa esta razão hoje; a leitura é ato deliberado,
			não vigilância automática.
			"""
	}

	affectedArtifacts: [
		"governance/build-time/work-governance.cue",
		"governance/build-time/command-rights.cue",
		"governance/build-time/event-validation.cue",
	]

	principlesApplied: [
		"P0 -- localização canônica única: fundamenta a rejeição da alternativa (a), que criaria segunda casa para o estado do trabalho.",
		"P3 -- correção por novos eventos, nunca por edição do passado: fundamenta a forma da correção contra registro externo e contra edição de stream.",
		"P10 -- agentes estocásticos recomendam, gates determinísticos validam: fundamenta dec 5 + dec 7. Aplicação build-time verificada em work-governance.cue taskCompletion.rationale, que invoca P10 explicitamente 'aplicados ao build-time'.",
		"P12 -- governança é código: fundamenta a FORMA das decisões 2, 5b e 7 -- o par novo, o effectClass e o predicado do ev-06 são declarados em CUE versionado, no lugar canônico que um fiscal lê, e não em prosa de ADR. NÃO é invocado para a segunda metade do princípio ('toda regra que importa é imposta automaticamente'): per N1, o motor não impõe as regras ev-* hoje, e declarar P12 aplicado nesse sentido seria afirmar o que o disco nega.",
	]

	defersTo: ["def-083"]

	supersedes: []

	rationale: """
		A escolha entre as quatro alternativas se resolve por BOOTSTRAP VS
		STEADY STATE, e é o que separa esta decisão do adr-024. O backfill do
		item (3) reconstruiu história de trabalho anterior à existência do log:
		não havia estado falso porque não havia estado, e a cadeia sintética
		foi o único modo de dar passado a um log nascente. Aqui o log existe, é
		autoritativo e roda; os três WIs foram executados SOB o regime. A
		alternativa (b) -- repetir o backfill -- produziria um task-approved
		com actor "founder" para ato que nunca ocorreu, indistinguível dos
		verdadeiros, escondendo a falha real atrás de cadeia sintética. O dec 3
		é a resposta: a admissão fica intocada e o log DECLARA A AUSÊNCIA DA
		APROVAÇÃO em vez de fabricá-la. É neste sentido preciso que
		task-reconciled sucede o backfill honestamente.

		OS 51 BACKFILLS EXISTENTES PERMANECEM VÁLIDOS. Não são dívida a migrar,
		não são erro a corrigir, e nada nesta decisão os condena. Foram o
		instrumento correto para o que eram -- o nascimento do log, com
		timestamps aproximados aceitos explicitamente pelo adr-024 sob a
		justificativa de que "o objetivo é rastreabilidade, não precisão de
		relógio". Este ADR PRESERVA o adr-024 item (3) intocado e INSTITUI o
		regime que o sucede em steady state; supersedes permanece vazio porque
		supersede-se regra vigente, não ato concluído -- e porque supersessão
		parcial não é representável no schema sem aposentar os itens (1), (2) e
		(4) do adr-024, que estão vivos e citados por múltiplos artefatos.
		NENHUMA fatia de higiene sobre os streams existentes decorre desta
		decisão.

		A rejeição da alternativa (a) é P0 aplicado literalmente: registro
		externo consultado pela derivação cria segunda localização canônica
		para o estado de uma tarefa, e o custo cresce com cada consumidor
		futuro da fila. A forma da correção é P3 -- "correção é por novos
		eventos, nunca por edição do passado": das quatro alternativas, apenas
		esta e a (b) são eventos, e a (b) forja o ato do decisor.

		P10 aplicado, com fundamento verificado. work-governance.cue invoca P10
		no taskCompletion -- "Alinhado com P10 (stochastic recommendations,
		deterministic gates) [...] aplicados ao build-time" -- e é exatamente
		esse mecanismo que este ADR estende. As duas primeiras sentenças de P10
		são incondicionais; a restrição a commands financeiros é a terceira.
		Dec 5 + dec 7 são P10 no seu enunciado direto: retirar o ato do agente
		estocástico e impor gate determinístico. P11 fica DE FORA: seu
		enunciado é inteiramente financeiro e criptográfico (CAS, DSSE, Merkle),
		e o uso build-time que work-governance.cue faz dele é analogia declarada
		por aquele artefato -- não extensão do texto de P11.

		Metadata de risco. reversibility medium, lida contra a escala do schema:
		medium é "reversível com esforço moderado (migração de dados, ajuste de
		consumidores)", e é onde esta decisão cai -- desativar o mecanismo
		exige remover o eventType, o tipo concreto, as transições, o par e o
		direito, mais ajustar os consumidores da derivação: esforço moderado,
		não trivial. NÃO é high, porque high exige "sem impacto em dados
		persistidos" e aqui há impacto: eventos emitidos permanecem num log
		append-only e os pares (defined, completed) gravados não desaparecem.
		NÃO é low, porque low é "irreversível ou com custo de reversão
		desproporcional" e o mecanismo é removível: o resíduo é limitado e
		inerte -- eventos de um tipo aposentado seguem legíveis e não exigem
		migração. blastRadius repo-wide: os três affectedArtifacts são o motor
		de governança e sua validação em CI -- a gramática de eventos, estados,
		comandos e efeitos muda para todo work-item, não só para os três.

		Escopo deliberadamente NÃO coberto: plannedOutputs fica omitido porque
		este ADR decide o MECANISMO, não sua aplicação -- reconciliar WI-067,
		WI-069 e WI-151 permanece ato do founder, um a um. Os pares
		(proposed, completed) e (rejected, completed) NÃO são adicionados, e o
		PORTADOR da restrição é o predicado do dec 7, não o enunciado do dec 1:
		#StateTransition não comporta dimensão de admissão e validStatePairs é
		declarativo, de modo que uma exceção incondicional ao ev-06 abriria a
		rota por construção -- inclusive para tarefa que o founder rejeitou.
		Com o predicado, a restrição tem onde morar; sem ele, seria norma sem
		gate. Qualificação honesta, per N1: o predicado só bloqueia de fato
		quando o pipeline ev-* for executável. validStatePairs é onde
		especulação vira permissão; (proposed, completed) entra por fato novo,
		se vier, com sua própria decisão.

		FRONTEIRA COM A FATIA DE SANEAMENTO DO MOTOR. Este ADR foi ENCOLHIDO
		deliberadamente na sessão de 2026-08-01, após o levantamento da
		superfície real do motor. Decide vocabulário e autoridade -- eventType,
		tipo concreto, par novo, não-alteração da admissão, direito exclusivo,
		effectClass e regime de evidência. NÃO decide, e não promete: onde o
		fiscal da restrição mora (runner de ev-* vs structural-check); a
		atualização do rebuild-projections.sh, cuja taxonomia de admissão sequer
		produz "defined"; a recomputação das projeções materializadas, obsoletas
		desde 3351afb; o destino das DEZ regras ev-* sem executor -- as 7 de
		event-validation.cue menos a ev-01, mais ev-08/09/10 de
		claim-expiration-validation.cue e ev-11 de completion-gates.cue, per a
		seção "Composição do pipeline efetivo"; o instrumento
		da razão do dec 8; e a DETECÇÃO de claim expirado, que nada emite -- as
		ev-08/09/10 validam o task-claim-expired QUANDO emitido, e nenhuma
		regra o dispara; o rebuild-projections.sh declara a lacuna em voz alta
		("Claim expiration is NOT auto-detected; trusts last event"). Tudo isso
		é a fatia de saneamento, registrada em def-083 -- o grosso pelos onze
		achados do levantamento, os dois últimos pela seção ITENS DELEGADOS,
		que esta decisão cria lá e cuja proveniência é outra: não vieram do
		disco, vieram deste ADR. O motivo do encolhimento: um ADR sobre um eventType
		novo não pode entregar enforcement num motor cujo sistema de fiscalização
		é o que está quebrado -- tentar fazê-lo foi o que inflou o custo declarado
		desta decisão a cada round de revisão.

		Tensão com axiomas: nenhuma. O atrito de N4 é consistente com ax-03
		(pagar custo de complexidade cedo). Sem entrada em tension-log. Lenses:
		nenhuma com match -- resolvido por princípios (P0/P3/P10/P12) e pelo
		precedente interno do adr-024.
		"""
}
