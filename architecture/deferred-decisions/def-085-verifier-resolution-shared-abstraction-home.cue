package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def085: artifact_schemas.#DeferredDecision & {
	id:    "def-085"
	title: "Onde deve viver a abstração compartilhada de resolução de verifier"
	date:  "2026-08-10"

	description: """
		adr-190 fixa a resolução de identidade de verifier (exact-ref ∧ active ∧
		compatible-grant) re-derivando o contrato mínimo do stream público
		registry.events. Essa derivação vive HOJE no consumidor — o join
		#TaskCompletionV2 em governance/build-time/task-spec-v2.cue. A pergunta
		deferida é onde a abstração compartilhada de resolução deve viver quando
		houver mais de um consumidor: centralizada localmente na Mesh, ou promovida
		ao Tekton como superfície de resolução do próprio #VerifierRegistry.
		"""

	deferralRationale: """
		Existe exatamente UM consumidor da resolução hoje. Abstrair agora anteciparia
		universalidade não provada: a forma da abstração seria desenhada a partir de
		um único caso, e o custo evitado por deferir é justamente o de congelar uma
		interface antes de observar qual parte da derivação é de fato comum. O custo
		de continuar deferindo é baixo enquanto o consumidor é único — nenhuma
		duplicação existe para divergir. Decidir a MORADA agora também escolheria
		prematuramente entre centralização Mesh-local e promoção upstream, sendo que
		a evidência que distingue as duas (a derivação é específica da completion V2
		ou é semântica geral do Registry?) só aparece com o segundo consumidor. Este
		deferimento NÃO promete promoção ao Tekton: mantém as duas alternativas
		abertas para decisão informada pela semântica comum efetivamente observada.
		"""

	triggerCalibrationRationale: """
		O gatilho detecta o EVENTO POSITIVO que dissolve a razão do deferimento — o
		surgimento de um segundo consumidor —, não a passagem do tempo. Conta a
		DECLARAÇÃO CANÔNICA de consumerhood exigida por adr-190 item 11
		(_verifierResolutionConsumer:), não a sintaxe interna da re-derivação: contar a
		declaração impede que uma refatoração da implementação silencie o deferimento, e
		a forma CUE fechada (campo hidden com dois-pontos) evita a contagem incidental
		que uma substring solta produziria (comentário + campo = duas ocorrências).

		DOIS TRIGGERS PORQUE OS KINDS CONTAM UNIDADES DIFERENTES (verificado no runner):
		recurrence scope=file-content conta ARQUIVOS com match dentro do pathScope
		(git grep -l), logo NÃO enxerga dois consumidores no mesmo arquivo;
		file-content-occurrence-count conta OCORRÊNCIAS dentro de UM path (re.findall),
		logo não enxerga consumidor em arquivo novo. A semântica multi-trigger do runner
		é OR, então a união cobre os dois cenários: trigger[0] pega o segundo consumidor
		DENTRO de task-spec-v2.cue (onde o primeiro vive e para onde o admission de C3
		tenderia); trigger[1] pega o segundo consumidor em outro arquivo do pathScope.
		Assim a topologia do código não é ditada pelo detector.

		Verificado na criação: zero declarações em governance/build-time/ — nenhum
		trigger nasce disparado. Após C2 a contagem esperada é 1; threshold 2 significa
		literalmente "apareceu um segundo".

		LIMITAÇÕES DECLARADAS (a cobertura NÃO é exaustiva; declarar uma só criaria
		impressão falsa de análise completa):
		(i) ADVISORY, não blocking: nenhum dos dois kinds é gateável no runner V1 — só
		adjacent-need/file-exists e temporal retornam gateable —, logo o disparo produz
		annotation/warn, nunca bloqueio de CI;
		(ii) trigger[0] depende do PATH CONCRETO configurado: se task-spec-v2.cue for
		renomeado, o runner retorna False silenciosamente (não há erro para path
		ausente);
		(iii) trigger[1] cobre apenas o pathScope ^governance/build-time/ — um segundo
		consumidor fora dele (e.g. em scripts/ci/ ou num artefato de BC) NÃO é contado;
		(iv) consumerhood OMITIDA escapa dos dois triggers: o sensor conta declarações,
		não consumidores. O gate
		scripts/ci/check-verifier-resolution-consumer-declaration.sh fecha a omissão
		PARA O IDIOMA CANÔNICO conhecido, mas uma implementação que resolva verifier por
		outra construção escapa — a fronteira entre a norma e a detecção está registrada
		em ten-018;
		(v) a declaração canônica REDUZ a contagem incidental (é sintaticamente
		específica) mas não transforma o runner em detector SEMÂNTICO de consumidores:
		uma linha que reproduza exatamente a sintaxe da declaração dentro do escopo
		contaria;
		(vi) ACOPLAMENTO GATE→SENSOR: o gate e este sensor compartilham a MESMA
		heurística de reconhecimento (o idioma canônico). Um arquivo que use o idioma
		sem ser consumidor da resolução é compelido pelo gate a declarar consumerhood —
		e essa declaração falsa alimenta os dois triggers, podendo disparar o
		deferimento sem que exista um segundo consumidor real. O gate ignora linhas
		comentadas, o que reduz o canal, mas classificação falsa por coincidência de
		idioma permanece possível (ten-018).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-190-verifier-identity-resolution-for-completion-v2.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			Com um único consumidor não há duplicação que possa divergir: o custo de
			protelar é nulo até existir o segundo. A partir daí passa a haver duas
			cópias da mesma regra de identidade podendo divergir silenciosamente —
			por isso o gatilho, e não uma revisita por calendário.
			"""
	}

	triggers: [{
		kind:      "file-content-occurrence-count"
		path:      "governance/build-time/task-spec-v2.cue"
		pattern:   "_verifierResolutionConsumer:"
		threshold: 2
	}, {
		kind:      "recurrence"
		scope:     "file-content"
		pattern:   "_verifierResolutionConsumer:"
		pathScope: "^governance/build-time/"
		threshold: 2
	}]

	status: "open"
}
