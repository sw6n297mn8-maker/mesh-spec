package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-185 -- Emenda o ramo remoto do #TaskOutput instalado pelo adr-184:
// artifact deixa de ser obrigatório e a carga semântica passa para
// effectDescription, com piso de trivialidade. Exigir o path contradizia a
// alternativa (c) que o próprio adr-184 rejeitou -- o mesh-spec nomeando o
// arquivo que o alvo deve escrever -- e não expressava efeito fan-out.
// Emenda DOIS PONTOS DO SHAPE -- a obrigatoriedade de artifact e a
// ausência de campo semântico próprio. Nenhum dos oito decision items do
// adr-184 é revogado; não supersede.

adr185: artifact_schemas.#ADR & {
	id:    "adr-185"
	title: "Tornar artifact opcional no efeito cross-repo e exigir a descrição do efeito"

	date: "2026-08-03"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	reversibility: "high"
	blastRadius:   "cross-artifact"

	context: """
		Estado precedente. O adr-184 instalou o ramo remoto do #TaskOutput em
		architecture/shared-types/task-output.cue com três campos obrigatórios:
		artifact, type e effectExpectedIn. Nenhuma instância o usa -- grep por
		effectExpectedIn devolve o schema, o work-governance.cue (linha 194, um
		comentário, e linha 633, dentro da string de requires -- nenhuma das
		duas é leitura executável do campo), os ADRs, os self-reviews, o def-084 e a
		guarda em generate-structure-index.py -- nenhuma task-spec e nenhum
		wave-task. E nenhum stream de work-events carrega effectProofs.

		Trigger: o PRIMEIRO USO REAL. Ao autorar as quatro task-specs da
		sequência aprovada -- pin do spec no mesh-runtime; avanço dos dois pins
		com regeneração; motor da cotação no mesh-runtime; tela da cotação no
		mesh-frontend-runtime -- OS QUATRO falharam. Medido, instanciando os
		quatro como task-specs reais com o constraint das task-specs ativado só
		para o teste: cue vet e cue vet -c saem 1 nos QUATRO. O texto do erro --
		outputs.N.artifact: incomplete value !="" -- é o que sai com -c; sem a
		flag, cue vet sai 1 imprimindo apenas "some instances are incomplete". Uma versão anterior deste
		texto dizia "três das quatro" -- número que o self-review não conseguiu
		reconstruir e que a reconstrução refutou: o caso do avanço dos pins tem
		um SEGUNDO output sem path, pelo achado (iii) abaixo. O harness dos
		quatro casos fica preservado no self-review report, porque número de
		casos sem harness é afirmação não-reproduzível.

		(i) CONTRADIÇÃO COM DECISÃO EXPLÍCITA. artifact obrigatório num efeito
		type "create" obriga o mesh-spec a NOMEAR o arquivo que o alvo deve
		criar. E o adr-184 REJEITOU essa alternativa por nome: a (c),
		"Reivindicação de autoria -- o output do mesh-spec nomeia o arquivo que
		o runtime deve escrever", com o motivo declarado logo em seguida:
		"Rejeitada por decisão explícita do founder em 2026-08-03: converteria
		em convenção a parede que os dois CLAUDE.md declaram e que nunca foi
		violada". Citação conferida contra o arquivo -- uma versão anterior
		deste texto emendava as duas frases numa aspa só. O shape fazia
		exatamente o que uma alternativa foi explicitamente rejeitada para
		impedir, no mesmo ADR e no mesmo dia. No caso do pin do mesh-runtime o
		arquivo nem existe e aquele repositório não tem convenção para ele --
		não há governance/, a governança de lá é docs/decisions.md, e que forma o
		arquivo tomaria é JULGAMENTO, não medição: nada no repositório-alvo a
		determina, e é precisamente por isso que nomeá-la daqui é usurpação.

		(ii) FAN-OUT INEXPRESSÁVEL. O avanço dos pins carrega a regeneração do
		baseline, cujos arquivos não são enumeráveis ex-ante. O dec 6 do adr-184
		resolveu fan-out do lado da PROVA -- gate nomeado mais conclusão -- e
		não voltou ao lado da EXPECTATIVA, onde artifact é uma string única.

		(iii) DESCOBERTA DE PERCURSO. O pin do mesh-runtime no caso do avanço é
		type "update" e TAMBÉM não tem path, porque quem o cria é a tarefa
		anterior, que ainda não executou. Logo artifact pode faltar por DOIS
		motivos distintos: a forma pertence ao alvo, ou o path ainda não existe
		no momento da autoria. Condicionar a opcionalidade ao type erraria este
		caso. Precisão sobre o estatuto desta afirmação: o que se EXECUTA é que
		output sem artifact falha o shape vigente; que o pin do runtime seja
		legitimamente "update" sem path é JULGAMENTO de desenho sobre uma
		task-spec que ainda não existe. Argumento, não medição -- e rotular
		julgamento como execução seria a confusão que a primeira regra de
		método mira.

		Alternativas avaliadas:
		(a) Manter o shape e contornar nas instâncias -- inventar um path para o
		pin, inventar um artifact para o fan-out. Rejeitada: as contorções
		ficariam silenciosas em quatro artefatos que viram precedente para todo
		uso futuro, e a alternativa (c) do adr-184 seguiria contradita pelo
		próprio shape que a materializa.
		(b) Condicionar artifact ao type -- obrigatório em "update", ausente em
		"create". Rejeitada pelo achado (iii): há output "update"
		legítimo sem path. A condicional erraria o caso e obrigaria a torcer o
		type para acomodar a ausência do path, que é pior que o problema.
		(c) Remover artifact do ramo remoto por completo. Rejeitada: quando o
		path existe e é descritivo -- o pin do frontend é governance/spec-pin.cue
		hoje -- omiti-lo perde informação verificável sem ganhar nada.
		(d) Ativar o constraint das task-specs NA MESMA FATIA, para o shape
		nascer com fiscal. Rejeitada, E A REJEIÇÃO MUDOU DE MOTIVO DURANTE A
		AUTORIA -- registrado porque o motivo descartado era fraco. O original
		("na ordem inversa o shape nasceria sem fiscal") só alcançava a ordem
		shape→constraint; na ordem constraint→shape a ativação é gratuita,
		medida: cue vet 0, cue vet -c 0, structural-check idêntico,
		structure-index idêntico. O motivo que sustenta é outro e apareceu
		depois: o "constraint inerte" NÃO É UM PROBLEMA, SÃO TRÊS. A auditoria
		determinística sobre cue export dos 131 streams mostrou que o gate irmão
		(work-events/_constraints.cue, inerte pelo mesmo mecanismo de prefixo
		"_") falha por commandId fora do regex (35 eventos, 14 streams),
		completionValidation ausente em task-completed (18 eventos, 18 streams,
		incluindo o WI-138 recente) e claimExpiresAt ausente em task-claimed (1
		evento) -- união de 23 dos 131 streams. Carregar a ponta task-specs
		desse novelo dentro de um ADR sobre shape de output cross-repo
		acoplaria uma decisão fechada a três decisões abertas. A ativação é a
		fatia IMEDIATAMENTE seguinte, e o custo de não a trazer aqui está
		declarado em N1.
		(e) Aceitar o adr-184 como está e concluir que os quatro casos é que
		estão mal formulados. Rejeitada, e o motivo é a regra de método que esta
		decisão registra: o mecanismo do adr-184 NUNCA FOI TESTADO CONTRA CASO
		REAL. Quatro rounds de self-review por sub-agente isolado revisaram o ADR
		contra o disco -- citações, shapes, execução do próprio schema -- e
		NENHUM instanciou uma task-spec com o ramo remoto. Os casos não estão mal
		formulados: são exatamente os quatro trabalhos que o trigger do adr-184
		nomeia.
		PRECISÃO, e ela é sobre o que os rounds FIZERAM, não sobre o que
		deixaram de fazer -- formulação mais forte e verificável, adotada
		depois que o round 4 do self-review desta emenda mostrou que a anterior
		afirmava de menos. O round 4 do adr-184 INSTANCIOU o ramo remoto: o
		relatório registra "valor fora da enumeração -> cue vet exit 1; campo
		estranho -> exit 1 (closedness preservada)", e #SubordinateRepo só é
		alcançável via effectExpectedIn. Instanciou SINTETICAMENTE, e sempre com
		artifact preenchido -- por isso o defeito não apareceu. Daí a segunda
		regra na sua forma correta: INSTANCIAR SINTETICAMENTE NÃO É USAR.
		Instância sintética usa o campo como o SCHEMA espera; caso real
		descobre que o campo NÃO PODIA ser preenchido. A diferença não é de
		rigor nem de quantidade de rounds: é de origem do dado. Enquanto o
		revisor escolhe os valores, ele escolhe valores que cabem.
		"""

	decision: """
		(1) TORNAR artifact OPCIONAL no ramo remoto do #TaskOutput e EXIGIR
		effectDescription. A forma passa a ser {effectExpectedIn,
		effectDescription, type, artifact?}. A opcionalidade NÃO é condicionada
		ao type: são dois motivos distintos para artifact faltar -- a forma
		pertence ao alvo, típico de "create", ou o path ainda não existe no ato
		da autoria, verificado no pin do runtime, que é "update" e nasce sem
		path porque quem o cria é a tarefa anterior.
		E o que `type` discrimina fica DECLARADO, porque sem artifact ele perde
		o referente óbvio: passa a qualificar o EFEITO, não o arquivo --
		"create" traz à existência no alvo algo que não existia, "update" altera
		algo existente, "validate" verifica sem alterar. Mantê-lo obrigatório é
		escolha, não inércia: é o único campo que ainda QUALIFICA o efeito quando
		não há path. Nota de vocabulário, porque o par se lê junto: "o
		discriminador" é termo que o adr-184 dec 2 cunhou para effectExpectedIn,
		que é o que discrimina os dois ramos da união -- `type` não discrimina
		ramo nenhum, e chamá-lo de discriminador induziria o erro oposto. Torná-lo opcional ou removê-lo não foi considerado nas
		alternativas -- gap apontado pelo round 2 do self-review e fechado aqui
		por DECLARAÇÃO, não por mudança de forma.

		(2) DAR DENTE AO effectDescription com strings.MinRunes(30), não
		string & !="". O campo carrega a semântica que o artifact ausente deixa
		de carregar: declara O QUE o efeito É, em consequência observável no
		repositório-alvo, nunca em termos de arquivo -- e é ele que o declarante
		da prova lê para escolher gate adequado ao efeito (adr-184 dec 6). Sem
		piso, aceitaria "x" ou "TODO": ambos falham com o piso, assim como um
		path curto (governance/spec-pin.cue, 23 runes). Path como CLASSE não é
		bloqueado -- scripts/ci/materialization-freshness.sh tem 39 runes e
		passa. Descrição real passa. Essa permissividade TEM consequência, e ela
		está nomeada em N5: path como descrição é o degenerado que reabre a
		alternativa (c) por outra porta. O piso é contra TRIVIALIDADE, não
		prova de substância -- 30 runes não impedem texto longo e vazio, e essa
		limitação fica declarada em N5 em vez de disfarçada. Precedente de forma
		no repositório: MinRunes(50) em policy.cue e production-guide.cue,
		MinRunes(20) em directory-meta.cue.

		(3) EMENDAR, NÃO SUPERSEDER -- E ESCREVER O PONTEIRO. A obrigatoriedade
		de artifact vive em TRÊS lugares, e os três são corrigidos neste mesmo
		commit. O primeiro é o SHAPE (shared-types/task-output.cue). O segundo é
		o PRODUCTION GUIDE de task-spec
		(architecture/production-guides/task-spec.cue), que a carregava em ONZE
		pontos -- comentário de cabeçalho; description, test e rationale do
		critério tq-tsg-03, este com severity "fail" exigindo "cada outputs[]
		tem artifact (path canônico não-vazio)"; action e detail do process;
		doneCriteria; finalValidation; e ainda collectFromFounder, gapPolicy e
		ifGap, que o primeiro passe de correção não alcançou e o round 5 do
		self-review encontrou. O TERCEIRO é o critério tq-wp-02 do
		architecture/artifact-schemas/wave-plan.cue, também severity "fail", e é
		o pior dos três: ele não apenas presume path -- ele EXIGE que
		"cada output.artifact usa um path que conforma com
		governance/repo-structure.cue", a estrutura DESTE repositório. Como o
		dec 1 endossa o remoto COM path quando o path já existe (o pin do
		frontend), escrever o caso que esta decisão declara BOM acionaria um
		critério de severity fail. Corrigido por escopo: o critério passa a
		valer para o ramo local, e o remoto com path conforma à convenção do
		repositório-alvo, inverificável daqui por construção. O PG NÃO é periférico: task-spec
		cai em defaultMode "manual" na authoring-policy, logo o guide é lido e
		confirmado section by section por quem autora a task-spec -- que é
		exatamente o autor das quatro. Sem corrigi-lo, o autor encontraria, no
		lugar onde lê, um critério de severity fail exigindo o path que esta
		decisão acabou de tornar opcional. E o pior dos onze pontos era o
		collectFromFounder: ele roda ANTES do workOrder, é a primeira coisa que
		o autor executa, e mandava coletar do founder "lista de artifacts" --
		exatamente o que o ramo remoto não tem.
		Correção do tq-tsg-03: artifact exigido para output LOCAL; para output
		REMOTO, effectDescription exigido e artifact opcional. Os cinco
		templates ficam INTOCADOS -- QUATRO deles apontam o preRead para
		outputs[0].artifact porque servem trabalho local (o quinto,
		tmpl-create-schema, nem referencia outputs, o que só reforça), e é o
		sexto template (dec 4) que serve o cross-repo.
		DUAS VERSÕES ANTERIORES DESTE ITEM ERRARAM AQUI, e o registro fica
		porque o eixo é o mesmo nas duas. A primeira alegava um segundo locus
		numa "frase de context do adr-184" que a busca não encontrou. A segunda
		concluiu daí que a obrigatoriedade vivia EXCLUSIVAMENTE no shape --
		conclusão sobre o REPOSITÓRIO tirada de uma busca cujo escopo era o
		CONTEXT de um ADR. É o erro de ESCOPO DE MEDIÇÃO que a P4 já nomeia
		neste mesmo artefato, repetido. Sem esta correção, o P0 declarado em
		principlesApplied seria FALSO: a emenda criaria duas fontes dizendo
		coisas opostas -- o shape permitindo a ausência, o PG proibindo-a com
		severity fail -- que é a patologia exata que este ADR existe para matar. Os OITO decision items do adr-184 seguem vigentes,
		conferidos um a um e nenhum revogado: (1) a semântica de condição de
		conclusão, (2) nome, vocabulário proibido, enumeração fechada e morada,
		(3) morada única, unificação e marcador de default, (4) a prova no
		evento, (5) a separação por tempo, (6) o gate adequado ao efeito, (7) o
		#ExecutionDependency intocado e (8) a obrigação sobre o bloco de
		evidência do adr-183. supersedes fica vazio: supersedê-lo aposentaria a
		decisão inteira quando nenhum item seu é revogado.
		E como o #ADR não tem campo de emenda, esta decisão EXIGE que o ponteiro
		para frente seja escrito DENTRO do adr-184 no mesmo commit, no formato
		do precedente que ela invoca -- o dec 8 do adr-184 fez exatamente isso
		com o adr-183 em 61e296c, mandando escrever e escrevendo. Sem essa
		obrigação, adr-184 ficaria em affectedArtifacts declarando uma alteração
		que nada especifica: o round 2 do self-review pegou precisamente isso.

		(4) DEIXAR O TEMPLATE PARA A FATIA SEGUINTE, com a dependência
		declarada. Nenhum dos cinco templates canônicos cobre efeito em
		repositório subordinado -- as applicability falam de artefato local, de
		schema em architecture/artifact-schemas/, ou de script deste
		repositório. A applicability de um sexto TEM DE descrever o que a tarefa
		produz, e com esta emenda isso deixa de ser "um artefato num path" e
		passa a ser "um efeito descrito num repositório subordinado": escrevê-lo
		antes de fixar o shape seria escrever contra alvo móvel. Fatia própria,
		E DE CLASSE SEMÂNTICA, com o custo declarado -- uma versão anterior
		deste item dizia "criação de instância de #TaskTemplate, não mudança de
		schema", e a execução refuta: #TaskTemplate.kind
		(architecture/artifact-schemas/task-template.cue:21) é enum FECHADO de
		cinco valores, em correspondência 1:1 com os cinco templates e com as
		cinco regras de execução por template de task-governance.cue (aquele
		arquivo reserva a palavra "override" para as entradas de scope "task",
		que são outras onze). Um sexto template com kind novo
		não unifica -- e reusar kind existente está excluído pelo próprio
		argumento acima, de que nenhum dos cinco cobre efeito em repositório
		subordinado. Logo a fatia seguinte EXIGE ADR PRÓPRIO e toca ao menos
		QUATRO arquivos: o schema (estender o enum), o arquivo de templates (a
		instância), task-governance.cue (a regra de execução) e o PRODUCTION
		GUIDE de task-spec, que enumera "5 templates canônicos" em oito pontos
		-- um sexto template torna os oito falsos. O quarto entrou depois de o
		round 5 mostrar que a lista de três repetia, projetada na fatia
		seguinte, o mesmo ponto cego que o round 4 encontrou nesta. Precedentes, os
		dois com decisionClass "structural": adr-042 estendeu o enum para o
		quarto valor (create-script) e adr-046 para o quinto
		(create-convention). O "exato" vale para a extensão do enum e para os
		três arquivos, não para o conjunto total tocado -- o adr-046 mexeu ainda
		num quarto (wi-027.cue). O erro importava porque a classificação é
		load-bearing: pela tabela do CLAUDE.md, instanciação NÃO exige ADR e
		mudança semântica exige -- dizer "instância" autorizava a fatia seguinte
		a nascer sem ADR contra dois precedentes.
		ESTATUTO desta ponte, declarado como o achado (iii) declara o seu: o que
		se EXECUTA é que o enum é fechado e que os dois precedentes o
		estenderam por ADR structural. Que o sexto template EXIJA kind novo --
		em vez de reusar um dos cinco -- é JULGAMENTO a partir desses
		precedentes e do argumento de applicability acima, não medição. A
		classificação escolhida é a segura: errar para o lado de exigir ADR
		custa um artefato; errar para o outro lado deixa mudança de schema
		entrar sem registro.
		Mas a fatia seguinte NÃO É LIVRE quanto ao conteúdo: o template DEVE
		carregar a norma da dec 2 -- efeito descrito em consequência observável
		no repositório-alvo, NUNCA em termos de arquivo. Motivo, vindo da
		lens-ai-agent-governance (aag-governance-as-code): policy que não vive
		no repositório não obriga o agente. Quem autora a task-spec lê o TEMPLATE
		e o PRODUCTION GUIDE -- o PG é corrigido aqui (dec 3), e o template é o
		que falta. Duas exigências concretas sobre o sexto: carregar a norma, e
		apontar o preRead para effectDescription em vez de outputs[0].artifact,
		como fazem QUATRO dos cinco atuais -- um preRead para path que pode não
		existir não resolve. Sem esta
		obrigação, a dec 2 depende de memória -- que é o modo de falha exato que
		a alternativa (c) do adr-184 foi rejeitada para impedir. LIMITE DESTA
		OBRIGAÇÃO, declarado: ela é, ela mesma, prosa de ADR sem gate. Nada
		verifica que a fatia seguinte a honre, e a circularidade é real -- o
		remédio para "a norma vive só em prosa de ADR" está também só em prosa
		de ADR. O que a torna diferente de nada é o destino: quando cumprida, a
		norma passa a viver onde o autor lê. Verificado que cabe: #TaskTemplate
		tem slot para ela em applicability (linha 24), rationale (25),
		preReads, steps e qualityGates (40).
		"""

	consequences: """
		Positivas:
		(P1) OS QUATRO CASOS PASSAM A CABER SEM TORCER, verificado por execução
		com o constraint das task-specs ativado só para o teste: os quatro
		instanciados como task-specs reais dão cue vet e cue vet -c exit 0. E o
		shape DISCRIMINA -- remoto sem effectDescription, repo fora da
		enumeração, campo estranho, effectDescription sem repo, type inválido e
		artifact vazio saem todos exit 1; local puro e remoto com path saem 0.
		(P2) A FORMA DEIXA DE OBRIGAR O PATH -- e é exatamente isso que ela faz,
		nem mais. Antes, o shape OBRIGAVA o mesh-spec a nomear o arquivo alheio,
		reintroduzindo por baixo a alternativa (c) que o adr-184 rejeitou por
		decisão explícita do founder; essa obrigação morre aqui. O que NÃO morre
		é a POSSIBILIDADE: nada na forma impede escrever um path dentro de
		effectDescription -- um path de 39 runes atravessa o piso (dec 2). Quem
		proíbe usá-lo como descrição é a NORMA da dec 2, e ela não tem fiscal.
		Afirmar que "texto e forma passam a dizer a mesma coisa" seria falso, e
		uma versão anterior desta positiva o afirmava. O que se pode afirmar é
		que a forma parou de EXIGIR o oposto do texto. O degenerado que sobra
		está nomeado em N5 e vigiado no falsificationCondition.
		(P3) O EFEITO GANHA CONTEÚDO PRÓPRIO E COM PISO. effectDescription
		obrigatório com MinRunes(30) impede o ramo remoto de degenerar em
		{repo, type} -- um efeito sem conteúdo -- e o piso foi testado contra os
		três degenerados mais prováveis.
		(P4) O ÚNICO DERIVADO TOCADO É O ÍNDICE, e o escopo da medição está
		declarado. Com só o shape aplicado, regenerate-derived --check tree e
		--check structure-index saem 0: a mudança de forma não move derivado
		nenhum. Mas o ARQUIVO DESTE ADR move: com ele em disco, --check
		structure-index sai 1 com uma ENTRADA nova no diff -- adr-185 na lista de
		#ADRBase -- enquanto tree segue 0. Daí derivedArtifacts
		declarar structure-index.cue. Uma versão anterior desta positiva dizia
		"zero derivado tocado ... resultado de execução, não suposição": a
		execução existia, mas media o shape sozinho, e a conclusão foi estendida
		ao commit inteiro sem medir. Erro de ESCOPO da medição, não de ausência
		dela -- mesmo eixo da primeira regra de método.
		(P5) A CLASSE DE DEFEITO FICA NOMEADA, COM A FRONTEIRA CERTA. "Arquivo
		de constraint com prefixo _" passa a ser antipattern reconhecível neste
		repositório -- e a auditoria que o revelou nasceu do harness desta
		emenda. MAS o prefixo "_" NÃO é defeito em si: os 58 _meta.cue do
		repositório o usam DELIBERADAMENTE, e directory-meta.cue:12-18 declara o
		porquê -- "para não casar os canonicalPathRegex dos schemas de instância
		do diretório" -- com a conformância validada pelo gerador (P10), não por
		unificação CUE, per adr-115. O defeito é usar o prefixo em arquivo cuja
		FUNÇÃO DEPENDE de ser carregado pelo CUE. A contagem fecha: 60 arquivos
		com prefixo "_", dos quais 58 são _meta.cue e estão CERTOS, e 2 são
		_constraints.cue e estão errados. Sem esta distinção, o próximo leitor
		"conserta" os 58 que estão certos e não toca nos 2 que importam. Como a
		fila do rationale, este reconhecimento não tem portador em disco: vive
		nesta prosa até a fatia de ativação lhe dar um.

		Negativas:
		(N1) O SHAPE NASCE COM FISCAL NUMA SUPERFÍCIE E SEM FISCAL NA OUTRA, E O
		CUSTO É ACEITO DE OLHOS ABERTOS. Correção de uma versão anterior desta
		negativa, que dizia "nasce sem fiscal" e era MEIA-VERDADE -- medido:
		injetando output remoto com descrição de 5 runes em governance/
		wave-plan.cue, superfície VIVA de #WaveTask, cue vet sai 1. O fiscal
		existe ali. O que não existe é do lado das task-specs: o
		governance/build-time/task-specs/_constraints.cue continua INERTE -- CUE
		ignora arquivos com prefixo "_", convenção herdada do Go -- e portanto
		as 138 task-specs seguem não-validadas contra #TaskSpec, inclusive as
		que usarem o ramo remoto desta emenda. É a dupla superfície que o
		adr-184 já declarou em N7, agora com consequência assimétrica de
		enforcement. Na prática os quatro casos provavelmente encostarão só na
		superfície inerte -- o wave-plan para em WI-142 e as task-specs vão a
		WI-161 -- o que muda o peso, não o fato. Provado nos dois sentidos: no
		repositório vivo, cue eval -e 'taskSpecs."WI-160".id' devolve "undefined
		field: id"; copiando o arquivo sem underscore, id passa a valer "WI-160",
		138 de 138 recebem id batendo a chave, e cue vet mais cue vet -c saem 0.
		A ativação é GRATUITA e foi DELIBERADAMENTE deixada para a fatia
		imediatamente seguinte -- o argumento que colava os dois assuntos caiu
		quando a auditoria mostrou que o "constraint inerte" é novelo de três
		problemas. A janela de exposição é curta por desenho, não por acidente.
		(N2) SEGUNDA AUTORIDADE APARENTE sobre repositório soberano, herdada do
		adr-184 e não resolvida aqui: uma task-spec do mesh-spec segue nomeando
		efeitos em outro repositório. O nome do campo e a enumeração mitigam a
		leitura errada; não a eliminam. Esta emenda REDUZ a superfície -- o path
		deixa de ser obrigatório -- sem fechá-la.
		(N3) A EMENDA NÃO TEM CAMPO PRÓPRIO NO SCHEMA. O #ADR só expressa
		supersessão, e a relação de emenda vive em prosa -- context, rationale e
		o ponteiro escrito no adr-184. Nada gateia essa prosa: def-083 registra
		em D3 que "hoje só campos estruturados como defersTo são alcançáveis, e
		nem esses são verificados". Esta decisão acrescenta mais um ponteiro
		não-verificado.
		(N4) O TEMPLATE CONTINUA AUSENTE. As quatro task-specs, quando escritas,
		usarão tmpl-create-instance@v1 contra a própria applicability dele, até
		a fatia seguinte existir. Contorção conhecida, datada e com dono -- mas
		viva no intervalo.
		(N5) O PISO DE 30 RUNES NÃO PROVA SUBSTÂNCIA, E UM DEGENERADO É PIOR QUE
		OS OUTROS. Impede "x", "TODO" e um path curto; não impede texto longo e
		vazio, nem descrição que não permita escolher gate; e 30 espaços em
		branco passam (executado). Mas o caso a NOMEAR é outro: PATH COMO
		effectDescription. scripts/ci/materialization-freshness.sh tem 39 runes
		e atravessa o piso -- logo é possível, sem violar forma nenhuma,
		escrever o arquivo alheio justamente no campo que existe para não
		nomeá-lo. Isso REABRE A ALTERNATIVA (c) DO adr-184 POR OUTRA PORTA: em
		vez de o shape OBRIGAR o path, o shape PERMITE que ele volte por dentro
		do campo semântico -- e agora invisível, porque nenhum gate o vê. É o
		modo de falha mais provável, por ser o mais fácil de escrever quando o
		autor não sabe descrever o efeito. NÃO tentar bloqueá-lo por forma é
		decisão, não omissão: um regex anti-path seria frágil e o falso positivo
		ensinaria a contorná-lo -- escrever o mesmo path com espaços, por
		exemplo -- o que é pior que não ter regra, porque produz conformidade
		aparente. A substância permanece NORMA, não shape (mesma posição que o
		adr-184 assumiu para effectProofs: "o vínculo é NORMA, não shape"), com
		TRÊS portadores: o falsificationCondition, que a vigia; o production
		guide de task-spec, que passa a dizê-la em três lugares ("NUNCA um
		path") e é lido section by section por quem autora; e a obrigação do
		dec 4, que a levará ao template. Uma versão anterior contava dois e
		dizia que a norma vivia só em prosa de ADR -- verdade antes de o dec 3
		corrigir o PG, falsa depois.
		"""

	falsificationCondition: {
		condition: """
			Esta emenda estará errada se effectDescription virar campo de
			preenchimento ritual -- descrições que atravessam o piso de 30 runes
			sem permitir a um terceiro dizer qual gate do repositório-alvo
			cobriria aquele efeito -- caso em que o ramo remoto terá trocado um
			campo que mentia (artifact obrigatório nomeando forma alheia) por um
			que não diz nada. O CASO ESPECÍFICO, e o mais provável: a
			effectDescription preenchida com um PATH do repositório-alvo, ou com
			um path parafraseado. Aí a emenda não terá apenas falhado em ganhar
			conteúdo -- terá REABERTO a alternativa (c) do adr-184 por outra
			porta, com o agravante de a reabertura ser invisível ao shape, que a
			deixa passar por construção (N5).
			"""
		observableSignal: """
			Leitura das effectDescription das task-specs com ramo remoto, com
			DUAS perguntas: (a) a descrição permite escolher gate adequado ao
			efeito, per adr-184 dec 6? (b) a descrição É um path, ou um path
			parafraseado? "Não" em (a) ou "sim" em (b), em amostragem
			recorrente, significa campo ritualizado.
			ROTA DECLARADA: isto NÃO é impossibilidade. É um validation-prompt
			(architecture/validation-prompts/, QUATORZE hoje -- o diretório tem 15
			arquivos e o décimo-quinto é o _meta.cue; incluindo
			validate-adr.cue) -- a camada advisory e NÃO-BLOQUEANTE que o
			adr-040 institui exatamente para dimensão interpretativa. P10 proíbe
			LLM como GATE; prompt advisory não é gate, e uma versão anterior
			deste sinal fechava a porta invocando P10, o que era aplicá-lo além
			do escopo dele. O prompt NÃO é criado nesta fatia, e o motivo é
			simétrico ao da própria decisão: não existe uma única instância do
			ramo remoto para revisar, e prompt sem corpus é ritual pela mesma
			razão que o campo seria. A rota fica NOMEADA para quando o corpus
			existir; até lá, o piso mecânico cobre a trivialidade e o resto é
			leitura humana.
			"""
	}

	affectedArtifacts: [
		"architecture/shared-types/task-output.cue",
		"architecture/production-guides/task-spec.cue",
		"architecture/artifact-schemas/wave-plan.cue",
		"architecture/adrs/adr-184-cross-repo-effect-as-completion-condition.cue",
	]

	// Novo, criado por esta decisão. O check-self-review.sh reprova hoje com
	// "missing self-review report" para este ADR -- executado.
	plannedOutputs: [
		"governance/build-time/self-reviews/adr-185-optional-artifact-and-effect-description.self-review.cue",
	]

	// Regenerado como consequência da existência deste arquivo, não do shape:
	// o índice lista os ADRs. Medido -- ver P4.
	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: [
		"P0 -- localização canônica única, aplicado ao SIGNIFICADO e não só ao arquivo: o adr-184 declarou a soberania do alvo sobre a forma no texto e a negou no shape, deixando a mesma regra em dois lugares dizendo coisas opostas. O dec 1 devolve a regra a uma localização única -- MAS só porque o dec 3 corrige o production guide de task-spec no mesmo commit. Sem essa correção, esta aplicação de P0 seria FALSA por construção: o shape passaria a permitir a ausência de artifact enquanto o critério tq-tsg-03 do PG continuaria exigindo o path com severity fail, criando exatamente a duplicidade de significado que o princípio proíbe. O round 4 do self-review pegou isso; o registro fica porque um princípio declarado aplicado sem verificar as OUTRAS moradas do mesmo significado é declaração vazia.",
		"P12 -- governança é código, aplicado EM FORMA PARTIDA, e a partição é a informação. Primeira metade, APLICADA: a regra entra como shape CUE com piso mecânico, não como prosa de norma, e é imposta automaticamente na superfície viva do #WaveTask -- medido, injetando descrição de 5 runes em governance/wave-plan.cue dá cue vet exit 1. Segunda metade, NÃO honrada por inteiro: 'toda regra que importa é imposta automaticamente' falha na outra superfície, porque o constraint das task-specs segue inerte até a fatia imediatamente seguinte (N1), e falha no critério de SUBSTÂNCIA da descrição, deliberadamente humano por P10 (N5). Uma versão anterior deste bloco EXCLUÍA P12, apoiada na frase 'o shape nasce sem fiscal' -- que a medição do wave-plan refutou. A correção não é de texto: a exclusão de um princípio que se apoiava numa afirmação falsa era decisão de princípio errada, e desfazê-la é parte da correção.",
		"P1 governa código gerado versus escrito à mão, e não este objeto. P10 não é aplicado como princípio desta decisão: aparece como o LIMITE que impede a segunda metade de P12 de ser honrada por mecanismo, já que mecanizar 'a descrição é substantiva' seria usar LLM como gate.",
	]

	defersTo: []

	supersedes: []

	rationale: """
		A escolha se resolve por QUAL PROMESSA O SHAPE DEVE HONRAR. As
		alternativas (a) e (b) tratam o problema como acomodação -- contornar
		nas instâncias, ou condicionar ao type. A (c) trata como excesso --
		remover o campo. Nenhuma olha o que o shape estava contradizendo: uma
		alternativa que o próprio adr-184 rejeitou por decisão explícita do
		founder, no mesmo dia. O dec 1 escolhe o único recorte em que a forma
		para de dizer o oposto do texto, e o dec 2 impede que a folga assim
		criada vire vazio.

		TRÊS REGRAS DE MÉTODO, e as três nasceram de erros desta linhagem de
		decisões. A primeira ficou no rationale do adr-184: TODA AFIRMAÇÃO SOBRE
		O DISCO SE EXECUTA, INCLUSIVE AS QUE DIZEM "ISTO VAI FUNCIONAR" -- três
		ocorrências nomeadas lá, duas rejeições e uma aceitação, e o eixo é
		executar-versus-supor.

		A SEGUNDA entra aqui: INSTANCIAR SINTETICAMENTE NÃO É USAR. O adr-184
		passou por quatro rounds de self-review por sub-agente isolado, os dois
		últimos com execução obrigatória do schema em cópias do repositório --
		e o round 4 CHEGOU A INSTANCIAR o ramo remoto, provando discriminação
		com valor fora da enumeração e com campo estranho. Ainda assim chegou a
		main contradizendo uma alternativa que ele mesmo havia rejeitado. O
		motivo é o coração da regra: instância sintética usa o campo como o
		SCHEMA espera, sempre com artifact preenchido, porque quem escolhe os
		valores é o revisor -- e revisor escolhe valores que cabem. Caso real
		não escolhe: ele DESCOBRE que o campo não podia ser preenchido, que é
		precisamente o que os quatro trabalhos do trigger revelaram.
		Representabilidade não é propriedade do texto de uma decisão, nem do
		schema que ela instala, nem da bateria sintética que a testa; é
		propriedade do USO com dado que o autor não escolheu. Consequência
		operacional: mecanismo novo se fecha depois de instanciar CASO REAL,
		não depois de passar na própria bateria.

		A TERCEIRA entra aqui também, e é a mais recente: CAUSA SE AUDITA SOBRE
		OS DADOS, NÃO SE LÊ NA SAÍDA DE ERRO. Investigando o gate irmão, a
		primeira leitura da saída do cue vet deu "14 streams, uma causa". A
		auditoria determinística sobre cue export dos 131 streams deu 23 streams
		e TRÊS causas -- commandId fora do regex, completionValidation ausente,
		claimExpiresAt ausente. As causas se MASCARAM EM CASCATA: corrigir a
		primeira revela a segunda, e cada rodada de leitura mostra só a camada
		de cima. O método que a torna acionável é auditar os dados exportados
		contra o schema, campo a campo, em vez de contar linhas de erro. Foi
		esta regra que impediu esta fatia de nascer com um deferimento vigiando
		a condição errada.

		Metadata de risco. reversibility high, e a divergência é registrada
		porque o erro foi instrutivo. O agente inclinou medium, argumentando que
		reverter exigiria editar as task-specs que tivessem omitido artifact. O
		founder divergiu, e procede: (a) aquele custo mede reverter o adr-184,
		não esta emenda -- reverter ESTA é tornar artifact obrigatório de novo,
		o que reintroduz a contorção sem gerar migração; (b) alargar
		opcionalidade não quebra contrato, porque todo consumidor que lê artifact
		continua lendo quando ele existe -- restringir quebra, alargar não; (c)
		zero instâncias no ramo remoto, zero dado persistido, nenhum consumidor
		a ajustar, e o único derivado tocado é o structure-index, regenerável
		por script e não dado. Uma versão anterior desta perna dizia "zero
		derivado tocado" e a medição a refutou (P4); a perna foi REESCRITA, não
		removida, e as três -- (a), (b) e (c) -- seguem de pé. (Uma versão
		intermediária dizia "as duas que restam", contando uma remoção que não
		houve.) É a definição literal de high no schema. A leitura medium fica registrada como descartada, com o erro
		nomeado: mediu-se o custo da decisão errada.

		blastRadius cross-artifact. Sem o item de ativação do constraint, nenhuma
		FASE DE CI é tocada e nenhum gate novo é instalado -- precisão que uma
		versão anterior errava ao dizer "nem enforcement mudado", o que colide
		com a consequência positiva P1 e com o princípio P12 deste mesmo ADR
		(a numeração P1..P5 das consequências convive com a P0/P1/P10/P12 dos
		design principles; aqui são a positiva e o princípio): o conjunto de valores que cue vet
		aceita MUDA, e isso é enforcement mudando, na superfície viva do
		#WaveTask. Sobram QUATRO artefatos -- o shape, o production guide de
		task-spec, o critério tq-wp-02 do wave-plan.cue (os três do dec 3) e o
		ponteiro no adr-184. A contagem subiu duas vezes durante a autoria: dois
		até o round 4 encontrar o PG, três até o round 5 encontrar o tq-wp-02.
		Registrada com as duas subidas, porque o número final vale menos que o
		padrão que ele revela -- ver a fila. E o tipo é
		consumido por #TaskSpec e #WaveTask, ambos de work-governance. A leitura
		concorrente -- cross-cutting, porque governance/ e architecture/ seriam
		domínios distintos -- fica registrada como DESCARTADA com motivo:
		aquelas são zonas de DIRETÓRIO, não domínios. O domínio é
		work-governance e ele atravessa as duas por construção, tanto que o
		#TaskOutput já morava em shared-types/ antes desta emenda. Tratar
		fronteira de diretório como domínio faria quase toda decisão deste
		repositório ser cross-cutting e esvaziaria o enum.

		Relação com o adr-184: EMENDA, não supersessão. supersedes fica vazio
		porque supersedê-lo aposentaria a decisão inteira quando OS OITO itens
		seguem vigentes -- conferidos um a um no dec 3. Uma versão anterior
		dizia "seis dos oito", número que o round 2 refutou e que,
		ironicamente, enfraquecia a própria justificativa que deveria sustentar. Precedente interno: o adr-184 fez exatamente isto
		com o adr-183 no commit 61e296c -- escreveu ponteiro para frente dentro
		de um ADR já accepted e declarou a obrigação no seu dec 8. É precedente
		de UM COMMIT de idade, e é o forte; o par adr-057/adr-054, considerado
		antes, é mais fraco porque os dois entraram em main no mesmo merge, o
		que faz extensão de lote e não emenda de decisão já aterrissada.

		FILA QUE ESTA DECISÃO DEIXA, com dono e ordem: (i) ativar o constraint
		das task-specs -- gratuito, medido, imediatamente seguinte; (ii) alargar
		o regex de commandId -- e MEDIDO: isso NÃO torna o gate dos work-events
		ligável. Alargando o regex numa cópia, cue vet segue exit 1, porque 9
		dos 14 streams daquela causa também carecem de completionValidation;
		apenas 5 ficam limpos (WI-027, WI-030, WI-032, WI-033, WI-034). Uma
		versão anterior deste texto afirmava "fica ligável para 14 dos 23" --
		falso, e a correção veio de executar o alargamento em vez de deduzi-lo.
		(iii) decisão de regime sobre completionValidation, e ela é DUAS coisas,
		não uma: dos 18 streams, CINCO (WI-024, WI-025, WI-026, WI-039, WI-041)
		TÊM os dados de validação escritos FLAT no evento em vez de aninhados
		(wi-024.cue:35-37 -- validationRunId, artifactSnapshotHash e gatesPassed
		soltos logo abaixo do cabeçalho eventType..actor, que ocupa 29-34; uma
		versão anterior citava 29-34 como sendo os dados, e citava portanto o
		cabeçalho) -- conserto de forma, mecânico -- e TREZE não têm DADO DE
		VALIDAÇÃO nenhum: doze sem campo extra algum, e o décimo-terceiro
		(WI-020) com um summary, que não é dado de validação. Só sobre esses
		treze há decisão de regime. Essa
		decisão toca a premissa do adr-183, para o qual o #CompletionValidation
		é o idioma da prova contemporânea. (iv) #WorkEvent aceita campo
		arbitrário: _#workEventBase carrega "..." (work-governance.cue:90)
		enquanto o comentário sobre #WorkEvent afirma, em duas linhas seguidas
		(work-governance.cue:153-154), "União fechada de todos os tipos
		concretos de evento" e "Usado para validação — não permite campos
		arbitrários". O comentário mente, e a AMARRAÇÃO importa:
		os cinco streams com dados flat só passam hoje PORQUE a struct é aberta
		-- (iv) é a causa da tolerância que (iii) encontra. Nenhuma delas é
		deferimento consciente: são trabalho identificado com ordem, não
		trade-off com condição de revisita, e por isso defersTo fica vazio.
		PADRÃO OBSERVADO NA PRÓPRIA AUTORIA, registrado porque custou quatro
		rounds: os três loci da obrigatoriedade de artifact apareceram UM POR
		ROUND -- o shape era conhecido, o PG apareceu no round 4, o tq-wp-02 no
		round 5 -- e cada aparição expandiu o pacote e derrubou uma contagem
		declarada. A busca que os encontraria de uma vez é mecânica e simples:
		dado o nome do campo, listar TODO critério de qualidade cujo test o
		menciona, com a severity de cada um. Não é detecção de drift semântico;
		é uma pergunta bem posta -- quem mais fala deste campo? Ela não foi
		feita antes de escrever affectedArtifacts, e a consequência foi
		descobrir por rodada em vez de por varredura.

		LIMITAÇÃO DESTA FILA, declarada em vez de subentendida: ela NÃO TEM
		PORTADOR EM DISCO. Nenhuma task-spec até WI-161 a carrega e o def-083
		não a enumera -- logo a "ordem" existe apenas nesta prosa, e o item
		(iv), que é defeito VIVO de schema, passa a viver só dentro de um ADR.
		É exatamente o gap que a N3 cita de def-083 D3, agora com caso
		concreto. O que limita a exposição não é mecanismo: é o item (i) ser a
		fatia imediatamente seguinte.

		Tensão com axiomas: nenhuma. Sem entrada em tension-log.

		LENSES, com o resultado da avaliação e não só o veredito. As mesmas
		quatro candidatas verificadas no adr-184 --
		lens-cross-cutting-concern-integration, lens-platform-evolution-and-
		backwards-compatibility, lens-developer-and-integrator-experience e
		lens-distributed-systems-design -- não fazem match pelo mesmo motivo:
		ativam-se sobre o PRODUTO Mesh, e esta é governança build-time. A
		QUINTA, lens-ai-agent-governance, foi avaliada por exigência do founder
		e MUDOU DUAS COISAS -- o registro vai completo porque a primeira versão
		desta avaliação era rasa e o round 2 do self-review a derrubou. Ela é a
		única lens do repositório cujo objeto é o AGENTE, e duas condições de
		trigger encostam aqui: "calibrar intensidade de supervisão humana sobre
		agentes" e "codificar políticas de agente em artefatos versionáveis".
		O reasoningProtocol dela tem ONZE perguntas, não seis -- a primeira
		versão reportou seis e descreveu a 5 errado (ela é drift detection, não
		lifecycle). Rodadas todas: 1, 2 e 8 chaveiam em CAPABILITY com fronteira
		de autonomia, nível e estágio de lifecycle, variáveis que um campo de
		schema não tem; 3 (escalation), 4 (contrato de observabilidade) e 11
		(audit trail) supõem agente em operação, não artefato de build-time; 5
		supõe baseline e métrica de divergência, que não existem para um shape;
		7 (blast radius) já está respondida em campo de metadata.
		E há um filtro que a lens declara e que a primeira versão desta avaliação
		ignorou: as perguntas 9 e 10 carregam appliesWhen (linhas 248 e 254) --
		"capability já ultrapassou estágio de onboarding" e "capability em
		estágio de expansão ou maturidade com métricas estabelecidas". Se um
		campo de schema não tem estágio de lifecycle, esses appliesWhen não são
		satisfeitos e as duas saem por construção, pelo mesmo motivo que tira 1,
		2 e 8. A pergunta 6 NÃO tem appliesWhen, e é ela que sustenta a
		conclusão. O que a 10 fornece é NOMEAÇÃO -- Goodhart batiza um modo de
		falha que o falsificationCondition já descrevia -- não aplicação da
		lens: útil como vocabulário, e registrado como tal em vez de contado
		como pergunta que mordeu.
		A que morde de verdade é UMA. A 6 -- "A policy que governa essa
		capability está codificada no mesh-spec (CLAUDE.md, CUE schema,
		config)?" -- expôs que a norma "nunca em termos de arquivo" VIVIA só em
		prosa de ADR, isto é, NÃO onde o autor da task-spec lê. O tempo verbal é
		passado de propósito: foi essa pergunta que produziu a correção do PG no
		dec 3, e hoje a norma vive lá. Daí saiu também a obrigação nova no dec 4, com o conceito aag-governance-as-code por
		motivo: policy fora do repositório não obriga o agente. A 10 -- "as
		métricas proxy ainda correlacionam com o objetivo real?", que é Goodhart
		nomeado (aag-continuous-alignment-verification) -- não foi aplicada, pelo
		appliesWhen acima; o que veio dela foi o NOME do modo de falha que o
		falsificationCondition já descrevia para o piso de 30 runes, sob o qual
		o degenerado do path entrou explicitamente na condição em vez de ficar
		implícito.
		Resíduo declarado, e ele sobrevive ao appliesWhen porque é observação
		sobre o desenho e não aplicação do protocolo: a 9 chama "supervisão fixa
		independente de track record" de antipattern no meshImplication de
		aag-hitl-calibration (linha 170), e o
		observableSignal desta decisão fixa leitura humana. Mitigado pela rota
		de validation-prompt agora nomeada, não resolvido -- e não resolvê-lo
		aqui é consequência de não haver corpus, não escolha de conveniência.
		Conclusão: match PARCIAL COM CONTRIBUIÇÃO, por UMA pergunta -- a 6. A
		primeira versão concluía "contribuição nula" tendo rodado seis das onze;
		a segunda contou duas, sem ver o appliesWhen que desqualifica uma delas.
		Registrar as duas correções é o ponto: a lens que julga supervisão de
		agente pegou este agente supervisionando a si mesmo por amostra, duas
		vezes seguidas.
		"""
}
