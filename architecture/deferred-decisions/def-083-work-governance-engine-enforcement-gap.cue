package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def083: artifact_schemas.#DeferredDecision & {
	id:     "def-083"
	title:  "Saneamento do motor de work-governance — enforcement declarado sem executor"
	date:   "2026-08-01"
	status: "open"

	description: """
		O motor de work-governance é um corpo declarativo sem sistema de
		fiscalização correspondente. Levantamento de superfície executado em
		2026-08-01 (somente leitura, sobre o disco) enumerou ONZE achados:

		(1) ev-02 (transição válida), (2) ev-03 (actor tem autoridade para o
		command), (3) ev-04 (commandId único), (4) ev-05 (no máximo um claim
		ativo), (5) ev-06 (execução só após admission approved), (6) ev-07
		(taskVersion consistente) — as SEIS regras declaradas enforcement
		"procedural" em event-validation.cue, nenhuma executada por runner
		algum. A ev-03 é a mais consequente da lista: é nela que o adr-183
		pendura o direito exclusivo do founder sobre ReconcileTask.

		(7) O pipeline efetivo é MAIOR que event-validation.cue: a seção
		"Composição do pipeline efetivo" declara a união com
		claim-expiration-validation.cue (ev-08, ev-09, ev-10) e
		completion-gates.cue (ev-11). Os quatro são igualmente "procedural" e
		igualmente sem executor. Inventário correto: 11 regras ev-*, DEZ sem
		fiscal (as seis do achado anterior mais estas quatro), uma (ev-01)
		coberta por cue vet.

		(8) projection-drift.cue declara que "CI recalcula cada projeção
		registrada a partir das SoTs e compara com o arquivo commitado;
		drift > 0 → fail" — e nenhum workflow o executa.

		(9) scripts/ci/rebuild-projections.sh não tem modo --check (o próprio
		comentário do script declara "always overwrites") e não é invocado por
		nenhum workflow.

		(10) As projeções materializadas estão factualmente erradas em main:
		projections/ready-queue.cue não é recomputada desde 3351afb
		(2026-06-21, o squash do baseline) e lista WI-043 como ready;
		in-progress.cue declara rebuiltAt 2026-06-11 e zero itens em progresso
		enquanto work-events/wi-140.cue carrega três task-claimed consecutivos
		sem task-released nem task-claim-expired — violação viva do ev-05 que
		atravessou o CI.

		(11) A semântica de estado diverge entre o declarativo e o computado:
		#AdmissionState declara defined|proposed|approved|rejected, e o
		compute_state do rebuild-projections.sh inicializa admission em
		"proposed" para qualquer stream não-vazio — "defined" NUNCA é
		produzido. O único structural-check sobre o motor, sc-wg-01, é
		directory-pair-coverage: verifica que existe task-spec para cada
		stream, e não olha conteúdo, estado nem autoridade.

		── ITENS DELEGADOS — proveniência distinta dos onze achados ──────
		Os achados (1)-(11) acima vieram do LEVANTAMENTO DO DISCO. Os itens
		D-N abaixo têm OUTRA origem, e cada um declara a sua: fundir as
		origens corromperia a proveniência do mapa e faria o número "onze"
		flutuar a cada delegação futura. D1 e D2 vêm da DECISÃO adr-183, que
		os declara fora do próprio escopo e os deposita aqui; D3 vem da
		sessão de 2026-08-01, de erro observado no processo, não no motor.

		(D1) INSTRUMENTO DA RAZÃO task-reconciled/task-completed. A condição
		de falsificação do adr-183 (dec 8) é computável e NADA a computa —
		nenhum runner, projeção ou check a mede. O contraste que expõe a
		lacuna: os def-* têm scripts/ci/evaluate-deferred-triggers.sh e gate
		de carência; esta razão não tem equivalente algum. Enquanto assim
		for, a vigilância da própria decisão depende de leitura deliberada.

		(D2) DETECÇÃO DE CLAIM EXPIRADO. Categoricamente distinto do achado
		(7): ev-08/09/10 validam um task-claim-expired QUANDO ele é emitido
		(referência ao claim, fórmula do commandId, expiração de fato) —
		nenhuma delas o DISPARA. O rebuild-projections.sh declara a lacuna
		em voz alta: "Claim expiration is NOT auto-detected; trusts last
		event (...) Future WI: claim expiration runner". É a mesma lacuna
		que o cabeçalho de work-events/wi-043.cue registrou em 2026-07-30 e
		que o founder deixou explicitamente fora daquela fatia; aqui ela
		ganha morada em vez de seguir órfã. Prova viva do custo: wi-140.cue
		carrega três task-claimed consecutivos, nenhum expirado, achado (10).

		(D3) STRUCTURAL-CHECK DE REFERÊNCIA-EM-PROSA. Origem: sessão de
		2026-08-01 (não o adr-183). Regra pretendida: todo adr-NNN, def-NNN
		e ten-NNN citado em PROSA — rationale, description, comentário de
		cabeçalho — deve existir no disco. Hoje só campos estruturados como
		defersTo são alcançáveis, e nem esses são verificados; a citação em
		prosa não é alcançada por gate algum. O kind cross-file-id-exists já
		existe no schema de structural-check: é aplicação de mecanismo
		existente a uma superfície nova, não invenção de mecanismo.

		JUSTIFICATIVA POR FREQUÊNCIA, não por hipótese. Esta família de erro
		ocorreu QUATRO vezes numa única sessão (2026-08-01), todas
		verificadas: (a) def-060 citado como vivo quando seu status no disco
		é "withdrawn"; (b) o dec 7 do adr-183 descrevendo os triggers deste
		def na versão DESCARTADA — recurrence, quando os vivos são
		adjacent-need — defeito introduzido pela correção da rodada anterior,
		que corrigiu o def e não o ADR que o descreve; (c) a narrativa dos
		"três precedentes" no cabeçalho de work-events/wi-043.cue, que
		atravessou autoria E aprovação e precisou de erratum datado em main;
		(d) dp-10 atribuído a design-principles.cue, onde o grep retorna zero
		ocorrências. Quatro numa sessão é sinal de família, não de descuido.

		ESCOPO A RESOLVER NA FATIA, não aqui. Prosa é texto livre, então o
		check precisa de PADRÃO DE EXTRAÇÃO declarado — sem ele, o gate é
		irreprodutível, que é exatamente o que um gate determinístico não
		pode ser. E precisa de tratamento de FALSO POSITIVO: menção histórica
		a id revogado é legítima e deve passar (o def-060 citado no contexto
		correto de "foi retirado" é uso certo, não erro), enquanto o mesmo id
		citado como vigente é o erro que o check procura. Distinguir os dois
		é o desenho da fatia. Registrar o item sem registrar essa dificuldade
		produziria um check que reprova texto correto — e gate que grita em
		caso legítimo é abandonado, não obedecido.

		CUSTO DE RENUMERAR OU CONSOLIDAR ESTE ID — registrado aqui porque
		nenhum gate o cobra. QUATRO pontos do adr-183 referenciam "def-083"
		pelo id: dec 7 (onde a construção do fiscal é declarada pendência
		nomeada), N1 (que aponta quem constrói o fiscal), N9 (que aponta a
		seção ITENS DELEGADOS, D1 — o título da seção mudou para acomodar o
		D3 de outra origem, mas as duas palavras que o N9 cita permanecem) e
		o bloco FRONTEIRA do rationale (que
		divide o que fica no ADR e o que vem para cá). A dependência é
		assimétrica por desenho — o ADR delega, este def carrega — e NÃO é
		verificada: defersTo é campo livre no #ADR, sc-wg-01 é pareamento de
		diretório e não olha referências, e as citações em prosa não são
		alcançáveis por reference-exists. Consequência prática: deletar,
		renumerar ou fundir este def com outro quebra quatro apontamentos em
		silêncio. Quem o fizer, atualize os quatro no mesmo commit.
		"""

	deferralRationale: """
		O saneamento NÃO entra no adr-183 (task-reconciled) por decisão
		explícita do founder na sessão de 2026-08-01, após cinco rounds de
		review isolado. Trade-off concreto: cada round empurrava o adr-183 a
		absorver mais do motor, porque toda promessa de enforcement que ele
		fazia esbarrava numa camada que não funciona — o custo declarado do ADR
		inflou de nove para quinze pontos de crescimento ao longo das rodadas, e
		a fronteira do "motor" que ele declarava (três arquivos) revelou-se
		estreita demais duas vezes seguidas.

		Custo evitado ao deferir: um ADR sobre um eventType novo que carrega a
		reconstrução do sistema de fiscalização inteiro — escopo que nenhum
		review consegue fechar, porque cada camada examinada revela a seguinte.
		Custo de continuar deferindo: o motor segue sem fiscal, as projeções em
		main seguem erradas, e cada novo work-event entra sob um regime que
		declara regras que ninguém verifica — a exposição cresce
		monotonicamente com o volume de streams.

		O adr-183 permanece correto sob este deferimento porque declara o
		estatuto do que entrega: regra escrita no lugar canônico, não gate em
		execução (N1 e dec 7 daquele ADR). O que ele NÃO pode fazer é prometer
		determinismo — e não promete.
		"""

	triggerCalibrationRationale: """
		O trigger primário detecta a CONDIÇÃO DE REVISITA, não a exposição: o
		adjacent-need dispara quando .github/workflows/validate.yml passar a
		invocar um script de scripts/ci/ cujo nome referencie work-events ou
		event-validation — isto é, quando o fiscal dos ev-* for construído e o
		motivo de deferir deixar de valer. É o que o PG do tipo pede de um
		trigger: sinal de que o deferimento não se sustenta mais, não medida do
		dano acumulado.

		NOTA DE CALIBRAÇÃO CORRIGIDA (mesma sessão, após execução do runner). A
		primeira versão deste def usava recurrence sobre filename de
		work-events com threshold 5, sob a premissa de que o runner contaria o
		volume acumulado DESDE ESTE REGISTRO. Premissa falsa, verificada
		executando scripts/ci/evaluate-deferred-triggers.sh: o
		evaluate_recurrence com scope=filename faz git ls-files e conta valor
		ABSOLUTO sobre o estado atual do repo, sem state persistido entre runs
		— o próprio docstring do runner declara isso. O def nascia DISPARADO
		(131 >= 5), único entre os 83, e poluiria o briefing de vigilância de
		toda sessão futura com um sinal permanente e vazio. O erro foi afirmar
		semântica de runner sem executá-lo; o registro fica porque a calibração
		de trigger é onde esse tipo de suposição causa dano silencioso.

		COBERTURA DO SENSOR — declarada, não suposta. Os dois adjacent-need
		cobrem as duas moradas que o adr-183 dec 7 enumera para o fiscal:
		script cabeado no validate.yml, e structural-check novo sobre o motor.
		O regex do segundo é sc-wg-(0[2-9]|[1-9][0-9]) e não sc-wg-0[2-9]
		porque o repo já tem duas famílias além de 09 — sc-dlv-14 e sc-rew-15,
		11 das 126 ids em dois dígitos >= 10 — e um fiscal do motor é
		exatamente o tipo de coisa que vira família grande; o schema exige
		dois dígitos, então 02-99 é a faixa inteira. NÃO cobertas: (a)
		workflow próprio com script fora do validate.yml, que é o padrão
		dominante do repo (3 dos 6 workflows são gate de propósito único —
		deferred-trigger-check, self-review-check, codegen-validation) e não é
		ancorável a path fixo sem adivinhar o nome do arquivo; (b) fiscal com
		outro prefixo de id ou em arquivo de structural-check novo. Para essas
		duas, a rede é o temporal. Mecânica adicional registrada porque muda
		quem trava: file-contains é warn-only no runner V1 — só file-exists e
		temporal são gateáveis pelo gate de carência. Os dois primários
		SINALIZAM no briefing; quem eventualmente bloqueia é o temporal.

		O temporal de 90 dias é a rede, e a justificativa é específica, não
		genérica: o trigger primário detecta um evento POSITIVO — a construção
		do fiscal — que pode simplesmente nunca ocorrer. Sem rede, um
		deferimento cuja condição nunca se materializa nunca ressurge. O prazo
		vem do custo declarado (severity high, dano já observável em main), não
		de calendário nem de regulação: um motor sem fiscal, com projeções
		erradas em produção de spec, não deve atravessar um trimestre sem
		decisão explícita de manter ou resolver. DIVERGÊNCIA CONSCIENTE da
		heurística do PG do tipo ("temporal último recurso: se calendário ou
		regulação não driva, repensar"): aqui nem calendário nem regulação
		drivam, e o temporal fica assim mesmo, como rede de um sensor que
		cobre duas rotas de quatro — precedente vivo no repo em def-070..074,
		que usam temporal de 180d exatamente nesse papel.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-183-task-reconciled-founder-exclusive.cue",
		"governance/build-time/event-validation.cue",
		"governance/build-time/projection-drift.cue",
		"session:levantamento-superficie-motor-work-governance-2026-08-01",
	]

	costOfDeferral: {
		severity:    "high"
		blastRadius: "repo-wide"
		description: """
			High porque o dano já é observável, não potencial: duas projeções
			em main afirmam estado falso (ready-queue lista WI-043 como ready;
			in-progress declara zero enquanto wi-140 tem claim ativo), e uma
			violação de ev-05 atravessou o CI e está no disco. Repo-wide porque
			alcança todo work-item: a derivação de estado, a fila de trabalho,
			a autoridade de comando e a prova de conclusão dependem das regras
			não-verificadas. Assimetria a registrar: o custo NÃO é de correção
			futura — é de confiança presente. Quem lê projections/ hoje lê
			informação errada sem sinal de que está errada.
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    ".github/workflows/validate.yml"
			pattern: "scripts/ci/.*(work-events|event-validation)"
		}
	}, {
		kind: "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    "architecture/structural-checks/work-governance.cue"
			pattern: "sc-wg-(0[2-9]|[1-9][0-9])"
		}
	}, {
		kind:       "temporal"
		maxAgeDays: 90
	}]
}
