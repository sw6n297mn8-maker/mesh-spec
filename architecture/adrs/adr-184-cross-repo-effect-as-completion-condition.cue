package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-184 -- Estabelece que um output de task-spec pode nomear um EFEITO
// ESPERADO em repositório subordinado (mesh-runtime, mesh-frontend-runtime)
// como CONDIÇÃO DE CONCLUSÃO da tarefa -- registro de consequência, nunca
// reivindicação de autoria -- e situa a PROVA desse efeito no evento de
// conclusão, ao lado (não no lugar) da prova de tarefa do
// #CompletionValidation. Expectativa é pré-execução; prova é pós-execução.

// EMENDADO POR adr-185 (dec 3 daquele ADR): no ramo remoto do #TaskOutput,
// `artifact` deixou de ser obrigatório e entrou `effectDescription` com piso
// de trivialidade (MinRunes(30)). Motivo: exigir o path contradizia a
// alternativa (c) rejeitada AQUI — o mesh-spec nomeando o arquivo que o alvo
// deve escrever — e não expressava efeito fan-out. Nenhum dos oito decision
// items abaixo é revogado; quem materializar lendo este ADR precisa ler o
// adr-185 junto.

adr184: artifact_schemas.#ADR & {
	id:    "adr-184"
	title: "Estabelecer efeito cross-repo como condição de conclusão, provado no evento"

	date: "2026-08-03"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "repo-wide"

	context: """
		Estado precedente. O #TaskOutput tem dois campos -- artifact, string
		livre sem regex nem constraint de path, e type (create | update |
		validate). Até esta decisão ele existia DUAS vezes, em definições
		independentes de shape idêntico e em packages que não se importavam:
		governance/build-time/work-governance.cue (package build_time) e
		architecture/artifact-schemas/wave-plan.cue (package artifact_schemas).
		Os comentários dos dois lados afirmavam compartilhamento que não
		existia. Não há dimensão de repositório e não havia campo de prova. E
		não há verificação: varredura de 2026-08-03 mostra que
		completion-gates.cue menciona outputs apenas dentro de uma string de
		rationale, o sc-wg-01 pareia stream e task-spec por nome de arquivo sem
		olhar conteúdo, e o único consumidor real é
		scripts/ci/generate-structure-index.py, que lê EXCLUSIVAMENTE
		governance/**/wave-plan.cue -- nunca task-specs -- e mapeia outputs com
		type "create" para anotar a árvore DESTE repositório. Nenhum gate
		confere que um output declarado existe. A dependência é WI→WI:
		#ExecutionDependency prende os dois lados a ^WI-[0-9]{3}$.

		A parede. Os dois repositórios subordinados declaram, no próprio
		contrato de agente, que são o ÚNICO alvo de escrita dos seus agentes e
		que decisões locais vivem neles -- rtd em markdown no mesh-runtime,
		#RuntimeDecision em CUE no mesh-frontend-runtime. Nenhum dos dois tem
		id de tarefa: não existe, do outro lado, objeto para uma aresta de
		dependência apontar. A fronteira nunca foi violada, e é ela que torna o
		P1 auditável -- o repositório que decide o contrato não escreve o
		código que o materializa, e por isso "gerado, nunca escrito à mão" é
		verificável em vez de prometido (divisão QUE=spec / COMO=runtime,
		adr-157 e adr-148).

		Trigger, concreto e datado. O arco da jornada fechou spec-side: os seis
		streams de WI-156..161 carregam task-completed. O WI-159 e o WI-161
		declaram outputs INTEIRAMENTE dentro do mesh-spec -- contexts/ssc/
		api.yaml, schemas/events.cue, aggregate-manifests/, port-manifest.cue,
		domain-model.cue, glossary.cue. A consequência que faz esses artefatos
		importarem -- o motor da cotação no mesh-runtime e a tela da cotação no
		mesh-frontend-runtime -- não tem representação nenhuma no work-graph. E
		o desalinhamento já corre: o mesh-runtime não tem pin de spec algum e
		seu FF-CG-03 está vermelho porque o baseline commitado ficou atrás do
		spec main; o mesh-frontend-runtime está pinado em 9efd550, dezesseis
		commits atrás, contrato v2, enquanto o spec main carrega o v3 do
		adr-180 com uma terceira família (ssc-quotation-map, read-only) que
		aquele runtime não gera. São quatro trabalhos na fila -- pin no
		mesh-runtime; avanço dos dois pins com regeneração; motor da cotação;
		tela da cotação -- e três deles não tinham onde ser declarados.

		DUAS CORREÇÕES DE PERCURSO, registradas porque o método que as
		produziu é parte do que esta decisão ensina. (i) Um rascunho pôs a
		prova no OUTPUT. Abandonado por confusão de tempos -- o output é
		promessa pré-execução num artefato normativo cuja identidade é
		(id, version) -- e porque o motivo que sustentava a rejeição da
		alternativa (d), "um hash por evento", NÃO EXISTE: gatesPassed é lista,
		e prova cross-repo já aterrissa nela (work-events/wi-159.cue).
		(ii) Um rascunho especificou o ramo local BYTE-IDÊNTICO, com
		discriminação por presença pura. Abandonado porque foi EXECUTADO e
		quebrou: cue vet ./... exit 1 com 243 valores incompletos, cue export
		do wave-plan falhando, e a cascata até o phantom-gate -- o gerador
		engole a falha do export em silêncio, devolve create_map vazio e
		fabrica phantoms, reprovando um gate reject. Em CUE, ramo sem campo
		obrigatório fica INCOMPLETO, não errado, e a disjunção não resolve sem
		marcador de default. (iii) A morada do tipo unificado migrou de
		wave-plan.cue para shared-types/ quando a zona correta foi finalmente
		examinada -- ver rationale.

		Alternativas avaliadas:
		(a) Manter fora do work-graph -- os efeitos downstream vivem só nos
		logs de rtd dos runtimes. Rejeitada: parte a fila de trabalho em três
		casas, e o mesh-spec deixa de poder responder quando a PRÓPRIA tarefa
		terminou. Não é hipótese: é o estado que o trigger descreve.
		(b) Instalar motor de task-governance em cada runtime e ligar por
		dependência WI→WI cross-repo. Rejeitada por SOBERANIA: contradiz o que
		os contratos dos runtimes declaram, e cobra dois motores novos para
		expressar quatro tarefas. Precisão: adotar o motor é decisão legítima
		de cada runtime, por rtd ou ADR próprio -- o que se rejeita é torná-lo
		PRÉ-REQUISITO desta decisão.
		(c) Reivindicação de autoria -- o output do mesh-spec nomeia o arquivo
		que o runtime deve escrever. Rejeitada por decisão explícita do founder
		em 2026-08-03: converteria em convenção a parede que os dois CLAUDE.md
		declaram e que nunca foi violada.
		(e) Generalizar a verificação spec-side no padrão do
		.github/workflows/codegen-validation.yml, que já faz checkout do
		mesh-runtime a partir daqui e roda scripts/ci/validate-codegen.sh.
		Rejeitada: o harness é sob medida para o pipeline de codegen -- cinco
		passos, exit-map pré-fixado, um alvo único -- e generalizá-lo por
		repositório e por tarefa faria o spec EXECUTAR o CI dos subordinados,
		invertendo a divisão QUE/COMO que a alternativa (c) foi rejeitada para
		preservar. O write-back daquele harness já é def-065; def-084 nasce
		relacionado a ele.
		NOTA: a alternativa (d) -- prova no evento de conclusão -- foi
		ADOTADA, e é o dec 4.
		"""

	decision: """
		(1) ESTABELECER que um #TaskOutput pode nomear efeito em repositório
		subordinado com a semântica de CONDIÇÃO DE CONCLUSÃO: a tarefa do
		mesh-spec só está concluída quando aquele efeito existir. NÃO é ordem
		de serviço e NÃO é reivindicação de autoria -- o repositório-alvo
		permanece soberano sobre implementação, forma e cronograma. O que o
		mesh-spec declara é o que conta como concluído AQUI, nunca o que se
		escreve LÁ.

		(2) NOMEAR o discriminador effectExpectedIn, com vocabulário de
		EXPECTATIVA e nunca de produção -- ficam proibidos producedIn, writesTo,
		createsIn e equivalentes, porque quem lê a task-spec não lê este ADR
		junto. O valor é #SubordinateRepo, enumeração FECHADA (mesh-runtime,
		mesh-frontend-runtime): admitir um quarto repositório é ato de ADR, não
		digitação. MORADA CANÔNICA de #SubordinateRepo: architecture/
		shared-types/task-output.cue, ao lado do #TaskOutput unificado.

		(3) UNIFICAR #TaskOutput numa morada única -- architecture/shared-types/
		task-output.cue -- e aplicar a união UMA vez. work-governance.cue e
		wave-plan.cue passam a importar shared_types e declarar
		#TaskOutput: shared_types.#TaskOutput. A união é discriminada por
		PRESENÇA RESOLVIDA POR DEFAULT: o ramo local carrega o marcador `*`,
		sem o qual a disjunção não resolve e o repositório inteiro sai vermelho
		(execução registrada no context). O marcador vive no SCHEMA, então as
		138 task-specs e o wave-plan conformam SEM TOQUE. A unificação também
		torna verdadeiros, por construção, os comentários que afirmavam
		compartilhamento nos dois arquivos.

		(4) SITUAR A PROVA NO EVENTO DE CONCLUSÃO. #CompletionValidation ganha
		effectProofs: [...#EffectProof], LISTA ABERTA, com #EffectProof
		{repo · commit do alvo · gate nomeado · conclusão do gate como
		enumeração}. Precedente citado, não inventado: governance/build-time/
		codegen-validation-evidence.cue já registra gates e o par
		specCommit/runtimeCommit para prova cross-repo neste repositório;
		#EffectProof ecoa aquela forma no nível da tarefa.

		(5) SEPARAR POR TEMPO, não por nível. A EXPECTATIVA é pré-execução e
		vive no output: a task-spec é definição normativa cuja identidade é
		(id, version) e cujos outputs "devem existir ao final da execução". A
		PROVA é pós-execução e vive no evento. Pôr o commit no output faria
		artefato pré-execução carregar fato pós-execução, exigindo emenda de
		artefato normativo depois do trabalho -- sem bump de versão, sem
		evento, sem gate. Dentro do #CompletionValidation os dois hashes têm
		objetos distintos: artifactSnapshotHash prova ESTE repositório no ato
		da conclusão; effectProofs[].commit prova o repositório-alvo.

		(6) EXIGIR QUE O GATE NOMEADO SEJA ADEQUADO AO EFEITO -- escolha do
		declarante. FF-CG-03 (regenerate-and-diff) é o caso do fan-out GERADO,
		e é cego a trabalho hand-authored. Para efeito hand-authored -- que é o
		caso do motor e da tela da cotação, os dois trabalhos que motivam este
		ADR -- os gates são build-test (nos dois runtimes) e ff-fe-06 (no
		frontend), que rodam sem condicional. A conclusão é ENUMERAÇÃO porque
		os jobs cross-repo nascem SKIPPED sem vars.MESH_SPEC_CHECKOUT_ENABLED, e
		"pulado" nunca pode se apresentar como "verde". FRONTEIRA COM O
		CATÁLOGO: #EffectProof.gate fica DELIBERADAMENTE fora de
		completion-gates.cue, que nomeia gates da conclusão deste repositório --
		com ponteiro escrito lá, e com a consequência de que nenhum catálogo
		valida o nome. LIMITAÇÃO DECLARADA, não piso: um gate incondicional
		verde prova AUSÊNCIA DE REGRESSÃO no alvo, não PRESENÇA do efeito -- um
		commit vazio passa build-test. Foi verificado por execução: efeitos
		hand-authored reais foram removidos dos dois runtimes e os gates
		continuaram verdes. Exigir do declarante a afirmação "este gate
		falharia se o efeito fosse revertido" seria pedir afirmação sobre o
		disco que nada executa -- precisamente o que a regra do rationale
		proíbe. ESTATUTO EPISTÊMICO: prova APRESENTADA, não VERIFICADA, igual
		ao adr-183 dec 6.

		(7) NÃO ALTERAR #ExecutionDependency. A dependência permanece WI→WI
		local. Verificado nos quatro casos motivadores: toda aresta é entre WIs
		do mesh-spec. O que atravessa a fronteira é o OUTPUT, nunca a aresta --
		e não há aresta cross-repo a desenhar porque não há, do outro lado, id
		para apontar.

		(8) EXIGIR que o bloco de evidência do adr-183 item N4(iii) carregue
		effectProofs com a mesma forma quando materializado. Motivo:
		completionValidation vive só em #TaskCompletedEvent, e o N4(xv) daquele
		ADR manda a reconciliação concluir sob bloco próprio, NÃO sob
		#CompletionValidation -- logo tarefa com effectExpectedIn concluída por
		task-reconciled ficaria com expectativa e sem slot de prova. Um tipo,
		dois portadores. Ponteiro para frente escrito no adr-183, porque quem o
		materializar lendo-o precisa saber.
		"""

	consequences: """
		Positivas:
		(P1) OS QUATRO TRABALHOS GANHAM CASA ÚNICA. Três dos quatro não tinham
		onde ser declarados. O ganho é de EXPRESSIBILIDADE, não de execução:
		nenhum deles passa a ser executado por isso.
		(P2) O mesh-spec passa a poder responder QUANDO A PRÓPRIA TAREFA
		TERMINOU -- com a ressalva honesta de que, sem verificador, responde
		"quando alguém DECLAROU que terminou". WI-159 e WI-161 são a prova do
		problema: task-completed com todos os outputs no disco e a consequência
		que os justifica inexistente.
		(P3) A PAREDE FICA EM CUE TIPADO, não em prosa de dois CLAUDE.md. O nome
		effectExpectedIn e a enumeração fechada são a fronteira em forma
		verificável por cue vet.
		(P4) A GUARDA NO ÍNDICE é mecânica. O generate-structure-index.py filtra
		pela presença do discriminador, em vez de depender de alguém lembrar.
		(P5) O FAN-OUT GERADO reusa gate existente (FF-CG-03) em vez de inventar
		medição de cobertura cross-repo -- com os limites do dec 6 declarados.
		(P6) A UNIFICAÇÃO CORRIGE DUPLICAÇÃO PRÉ-EXISTENTE. #TaskOutput tinha
		duas definições e dois comentários que afirmavam compartilhamento
		inexistente; passa a ter uma morada e comentários verdadeiros.

		Negativas:
		(N1) A PROVA É APRESENTADA, NÃO VERIFICADA -- consequência central. O
		mesh-spec não lê o CI do alvo. Nada impede declarar commit e gate que
		não estava verde. Sem mitigação estrutural: verificar exige canal
		cross-repo, registrado em def-084 com gatilhos codificados.
		(N2) NENHUM GATE CONFERE QUE O OUTPUT EXISTE -- e não conferia o LOCAL
		tampouco. Esta decisão acrescenta CAMPO DE PROVA, não verificação. O
		buraco é pré-existente e é o achado (11) de def-083 (sc-wg-01 não olha
		conteúdo, estado nem autoridade); referenciado aqui, não delegado --
		delegar exigiria entrar nos ITENS DELEGADOS daquele artefato com
		proveniência declarada, e esta decisão não cria o buraco.
		(N3) SEGUNDA AUTORIDADE APARENTE sobre repositório soberano. O nome do
		campo e a enumeração mitigam a leitura errada; não a eliminam. A parede
		fica preservada por NOMENCLATURA, que é mais fraca que estrutura.
		(N4) O motor cresce em SEIS pontos: (i) união com default em
		#TaskOutput; (ii) #SubordinateRepo; (iii) #EffectProof + effectProofs em
		#CompletionValidation; (iv) a GUARDA no generate-structure-index.py --
		guarda, não necessidade: o uso vivo atravessa o pipeline sem ela, mas o
		namespace de paths colide entre os três repositórios e a colisão é
		silenciosa; (v) a prosa de taskCompletion.requires, que o dec 4 tornaria
		incompleta -- mesma classe dos itens (vi)/(xiv)/(xv) do N4 do adr-183;
		(vi) o self-review report de artifact-schema exigido porque o dec 3
		edita wave-plan.cue, verificado por execução do check-self-review.sh.
		(N5) A ENUMERAÇÃO FECHADA vira ponto de manutenção E DE ORDERING: o ADR
		de nascimento de um repositório subordinado passa a ter obrigação
		implícita de editar este tipo, e nada a impõe.
		(N6) ACOPLAMENTO COM O adr-183 na MESMA estrutura de conclusão, não só
		no mesmo arquivo. Endereçado pelo dec 8 e pelo ponteiro escrito lá.
		(N7) DUPLA SUPERFÍCIE DE DECLARAÇÃO. Unificar faz effectExpectedIn
		aparecer também em #TaskSpec.outputs, não só em #WaveTask.outputs -- duas
		superfícies para a mesma expectativa (governance/wave-plan.cue e
		task-specs/wi-NNN.cue), sem regra de qual é autoritativa nem gate de
		concordância.
		(N8) O GATE NOMEADO PODE NÃO COBRIR O EFEITO, e nada verifica que cobre.
		Refutado por execução (dec 6). Adequação não é verificação, e isto NÃO
		está coberto por N1: N1 é "ninguém verifica a prova"; isto é "mesmo
		verificada, a prova não implica o efeito".
		(N9) PROVA PENDURADA. O commit registrado pode virar irresolvível por
		reescrita de histórico no alvo -- squash-merge, force-push, branch
		deletada. Nada detecta ponteiro morto, e o falsificationCondition cobre
		divergência de conteúdo, não morte de referência.
		(N10) O GATILHO SEGUE REPRODUZÍVEL. Nada obriga tarefa com efeito
		cross-repo a declará-lo, e nada obriga tarefa com effectExpectedIn a
		preencher effectProofs -- expectativa sem prova passa em cue vet. O
		vínculo é NORMA, não shape. Uma futura WI pode fechar exatamente como
		WI-159 e WI-161 fecharam.
		(N11) COLISÃO DE NAMESPACE DE PATH. artifact é string livre e os três
		repositórios compartilham raízes (contexts/, governance/, scripts/). Um
		path remoto é indistinguível de local exceto pelo discriminador.
		(N12) A ZONA shared-types/ NÃO ESTÁ NO MAPA do check-self-review.sh. O
		tipo load-bearing desta decisão passa a viver onde o gate de
		self-review não exige report -- verificado por execução.
		"""

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se o efeito declarado deixar de
			corresponder ao que o repositório-alvo fez -- se task-specs
			acumularem outputs remotos cuja prova aponta commit que não carrega
			o efeito, ou gate que não estava verde, ou se a expectativa for
			declarada e a prova nunca preenchida. Nesse cenário o campo vira
			carimbo de intenção, a conclusão da tarefa volta a ser verdadeira
			pela letra e vazia pelo propósito -- que é exatamente o estado que
			P2 corrige -- e o custo do mecanismo não compra nada.
			"""
		observableSignal: """
			Amostragem deliberada: para cada output com effectExpectedIn nas
			task-specs e no wave-plan, conferir no repositório-alvo que o commit
			citado existe e que o gate nomeado concluiu como registrado; e
			conferir que toda tarefa concluída com expectativa remota carrega
			effectProofs. LIMITAÇÃO DECLARADA (N1, N8, N10): a conferência é ato
			manual cross-repo, nenhum runner a executa, e automatizá-la é o
			conteúdo de def-084.
			"""
	}

	affectedArtifacts: [
		"governance/build-time/work-governance.cue",
		"architecture/artifact-schemas/wave-plan.cue",
		"scripts/ci/generate-structure-index.py",
		"governance/build-time/completion-gates.cue",
		"architecture/adrs/adr-183-task-reconciled-founder-exclusive.cue",
	]

	plannedOutputs: [
		"architecture/shared-types/task-output.cue",
		"architecture/deferred-decisions/def-084-cross-repo-effect-proof-verification.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: [
		"P0 -- localização canônica única: fundamenta a rejeição da alternativa (a), que criaria segunda e terceira casas para o estado de uma tarefa do mesh-spec; e fundamenta o dec 3, que corrige duplicação pré-existente de #TaskOutput em vez de agravá-la.",
		"P12 -- governança é código, aplicado PARTIDO, no idioma do adr-183. A PRIMEIRA metade se aplica: a condição de conclusão é tipo CUE versionado no lugar canônico que um fiscal lê, e há fiscal real -- a enumeração #SubordinateRepo rejeita valor inválido em cue vet, o shape de #EffectProof e o de effectProofs também, e a closedness segura campo estranho. A SEGUNDA metade ('toda regra que importa é imposta automaticamente') NÃO se aplica: nada obriga effectProofs quando há effectExpectedIn (N10), nenhum catálogo valida o nome do gate (dec 6), e nenhum gate lê effectExpectedIn (N2). Declarar a segunda metade aplicada seria afirmar o que o disco nega.",
	]

	defersTo: ["def-084"]

	supersedes: []

	rationale: """
		A escolha entre as alternativas se resolve por ONDE MORA A AUTORIDADE e
		por QUAL É O TEMPO DO FATO. As alternativas (a) e (b) tratam o problema
		como falta de mecanismo -- (a) aceita que não haja, (b) constrói dois
		motores para haver. A (c) trata como falta de alcance: se o mesh-spec
		planeja, que planeje o conteúdo. A (e) trata como falta de verificação e
		paga com inversão da fronteira. Nenhuma olha o que a fronteira PROTEGE:
		a divisão QUE=spec / COMO=runtime é o que torna o P1 auditável, e trocá-la
		por conveniência de planejamento custaria a propriedade em vez do
		mecanismo. O dec 1 escolhe o único recorte que expressa a dependência
		real sem tocar a parede. E o dec 5 resolve a segunda pergunta: expectativa
		e prova não são dois níveis, são dois TEMPOS, e cada um mora no artefato
		do seu tempo.

		REGRA DE MÉTODO, registrada porque três erros desta autoria a
		produziram: TODA AFIRMAÇÃO SOBRE O DISCO SE EXECUTA, INCLUSIVE AS QUE
		DIZEM "ISTO VAI FUNCIONAR". As três ocorrências, nomeadas: "um hash por
		evento" (rejeição da alternativa (d) por restrição que gatesPassed
		desmente); "a direção de import impede unificar" (rejeição da unificação
		por restrição que quality-gate.cue desmente no mesmo package); "ramo
		local byte-idêntico" (aceitação nunca executada, que quebrava cue vet,
		export e um gate reject). O eixo NÃO é aceitar-versus-rejeitar; é
		EXECUTAR-VERSUS-SUPOR. Rejeição é onde o viés mais mora, porque encerra
		a investigação; mas aceitação não-executada erra igual, e mais tarde.

		MORADA DO TIPO, com as duas rejeições declaradas.
		architecture/shared-schemas/ foi considerado e rejeitado: seu _meta
		restringe a zona a uso cross-BC, e #TaskOutput é build-time -- mover para
		lá exigiria emendar o escopo da zona.
		architecture/artifact-schemas/wave-plan.cue foi considerado e rejeitado:
		faria work-governance depender do schema do WAVE-PLAN por um tipo que não
		é sobre waves. Esse desconforto chegou a ser aceito como trade-off numa
		versão anterior desta decisão, com a esquisitice declarada no rationale;
		a correção veio da observação de que declarar desconforto quando existe
		conserto é aceitar a coisa errada de forma sofisticada.
		architecture/shared-types/ é a zona cujo _meta diz literalmente "tipos de
		baixo nível usados por múltiplos schemas" -- que é a descrição exata de um
		tipo consumido por #TaskSpec e #WaveTask em packages distintos.

		Metadata de risco. reversibility medium contra a escala do schema:
		desativar exige remover o ramo remoto, #EffectProof, effectProofs, a
		enumeração e a guarda, mais editar as task-specs que os usaram -- esforço
		moderado. NÃO é high, porque high exige "sem impacto em dados
		persistidos": effectProofs aterrissa em #CompletionValidation, dentro de
		task-completed, que materializa em work-events append-only. Registro de
		retratação: uma versão anterior deste rationale distinguia esta decisão
		do adr-183 alegando "resíduo em task-specs editáveis, não em log
		append-only" -- o dec 4 falsifica essa distinção, e as duas decisões
		deixam resíduo da MESMA natureza. O valor medium se mantém; a
		justificativa que o sustentava era falsa.

		blastRadius repo-wide, com a DIVERGÊNCIA DE LEITURA registrada porque é
		instrutiva ao contrário do usual. A inclinação inicial do agente foi
		repo-wide; o founder divergiu para cross-cutting por um argumento de
		QUANTO (a mudança é aditiva e opcional); o enum, porém, define repo-wide
		por O QUÊ é afetado -- "governança, CI, ou estrutura do repositório
		inteiro" -- e os affectedArtifacts são o motor de governança, um script
		de CI e um artifact-schema. O founder reverteu para repo-wide quando o
		disco corrigiu o critério. A leitura por QUANTO fica registrada como
		descartada, não como alternativa viva.

		Tensão com axiomas: nenhuma. Sem entrada em tension-log. Lenses: o
		trigger.conditions de quatro candidatas plausíveis foi verificado --
		lens-cross-cutting-concern-integration, lens-platform-evolution-and-
		backwards-compatibility, lens-developer-and-integrator-experience e
		lens-distributed-systems-design. Nenhuma faz match: todas se ativam sobre
		o PRODUTO Mesh (participantes, APIs, bounded contexts, serviços), e esta
		decisão é governança build-time do próprio repositório. Resolvido por
		princípios (P0, P12-partido) e pelo precedente interno adr-157/adr-148.

		RESIDUAIS ACEITOS COM RESSALVA, per exitOnMaxRounds do quality-gate após
		4/4 rounds de self-review: (i) o piso de adequação do gate foi rebaixado
		a limitação declarada (N8) em vez de virar critério -- exigi-lo seria a
		quarta ocorrência da família que a regra acima proíbe; (ii) a guarda do
		N4 item (iv) é guarda e não necessidade (declarado ali). Ambos ficam no
		texto, não no chat.
		"""
}
