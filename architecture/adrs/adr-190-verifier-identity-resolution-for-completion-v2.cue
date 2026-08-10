package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr190: artifact_schemas.#ADR & {
	id:    "adr-190"
	title: "Resolução de identidade de verifier para completion V2 (Slice C2)"
	date:  "2026-08-10"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	context: """
		Estado precedente. adr-188 estabeleceu #TaskCompletionV2 com as invariantes
		decidíveis SEM Registry (cobertura, verifier-correto componente-a-componente,
		só verified completa, no-orphan), deferindo explicitamente a resolução de
		verifierRef para versão ATIVA/AUTORIZADA. adr-189 (Slice C1) foi materializado
		integralmente e entregou, com precisão: (i) INTEGRIDADE CAUSAL do trust root —
		append-only por Git-prefix (scripts/ci/check-verifier-registry-append-only.sh)
		e quiescência terminal pós-revoked
		(scripts/ci/check-verifier-registry-terminal-quiescence.sh), somadas às
		invariantes estruturais do cue vet; (ii) REQUIRED BLOCKING de fato — o workflow
		.github/workflows/verifier-registry-check.yml está no required_status_checks do
		ruleset main-protection; e (iii) AUTORIDADE DECLARATIVA E EXAUSTIVA — a
		superfície governance/build-time/verifier-governance-authority.cue, founder-held
		e keyed pelas AÇÕES do domínio, com igualdade de conjuntos entre os event types
		da união adotada e as ações autorizáveis, enforçada por
		scripts/ci/check-verifier-governance-coverage.sh. O que C1 NÃO entregou, e este
		ADR também não assume: enforcement executor→autorização→append — nada prova que
		uma mutação executada consultou a authority surface antes de anexar o evento.
		O Registry permanece events: [] (machine-first). A fronteira que este ADR
		materializa é a decisão 8 do adr-189: um proofResult satisfaz um requirement
		somente se resolve para (id, version, revision) EXATO cuja projeção de lifecycle
		é "active" E existe grant efetivo compatível com o assertion schema exigido;
		effectiveGrantKeys sozinho NÃO é autoridade.

		Trigger e descoberta. Ao abrir C2 verificou-se por leitura que a superfície
		PÚBLICA do #VerifierRegistry adotado não sustenta esse predicado sozinha:
		projection.lifecycle é keyed por "id::version" e NÃO carrega revision (logo não
		prova exact-ref), e projection.effectiveGrantKeys são chaves
		"id::version::assertionSchemaRef" — mas o assertionSchemaRef de um verifier vive
		no seu CONTRATO, e o mapa de contratos (_contracts) é campo HIDDEN do schema,
		inacessível de outro tipo. Os dois fatos que faltam — a revision registrada e o
		assertionSchemaRef do contrato — existem no stream público registry.events
		(SoT event-sourced), de onde a projeção do próprio schema os deriva. Sem uma
		regra explícita de como um #VerifierRef resolve a um contrato registrado, C2 não
		tem como ser materializado com a identidade que adr-189 dec 8 exige.
		A mesma leitura registra um fato que altera o peso de um dos conjuntos do
		predicado: o invariante C do schema adotado (_capabilityCovered) já exige que
		toda versão não-revogada tenha grant efetivo para o assertionSchemaRef do seu
		próprio contrato — logo, num Registry válido, "active" implica grant compatível.
		Isso é load-bearing para entender a semântica real da resolução e está tratado
		na decisão 7.
		"""

	decision: """
		(1) ESCOPO desta decisão: exclusivamente a resolução de identidade de verifier
		para a completion V2. Nada além.

		(2) FONTE: o contrato mínimo de cada verifier é RE-DERIVADO do stream público
		registry.events (eventos "verifier-registered"), não de campo hidden nem de
		cópia. É projeção local de LEITURA sobre o SoT event-sourced — não cria segunda
		autoridade: a autoridade continua sendo events.

		(3) CHAVE DE LOCALIZAÇÃO ≠ IDENTIDADE. "id::version" é apenas a CHAVE DE
		LOCALIZAÇÃO do contrato registrado — a mesma granularidade em que o Registry
		governa lifecycle e grants, e por isso a chave pela qual se ENCONTRA o contrato.
		A IDENTIDADE que efetivamente RESOLVE continua sendo a tripla (id, version,
		revision): localizar o contrato por (id, version) é o primeiro passo, não a
		resolução. revision participa da identidade — ver item 4.

		(4) REVISION EXATA: a revision do #VerifierRef DEVE bater exatamente com a
		revision do contrato registrado sob aquele (id, version). Divergência de digest
		não resolve, ainda que id e version coincidam.

		(5) ASSERTION SCHEMA vem do CONTRATO REGISTRADO (contract.assertionSchemaRef) —
		não é declarado pelo requirement nem inferido: é propriedade do verifier.

		(6) ACTIVE vem de projection.lifecycle["id::version"] == "active". deprecated e
		revoked NÃO resolvem.

		(7) GRANT vem de projection.effectiveGrantKeys, exigindo a chave
		"id::version::<assertionSchemaRef do contrato>" — grant COMPATÍVEL, não grant
		qualquer. effectiveGrantKeys isolado não é autoridade (adr-189 dec 8).
		REDUNDÂNCIA ATUAL DECLARADA — válida sob a fronteira tipada exigida pelo item 9
		(o Registry consumido É um #VerifierRegistry, logo suas invariantes valem): sob
		a versão adotada de #VerifierRegistry, "active"
		JÁ implica grant efetivo compatível, pelo invariante C (_capabilityCovered,
		verifier-types.cue) — verificado por teste: um verifier active sem grant, ou com
		grant de outro assertion schema, não passa cue vet. Portanto esta condição é
		HOJE redundante em poder de rejeição. Ela permanece explícita no predicado
		porque autorização por assertion schema é parte da DEFINIÇÃO Mesh de "verifier
		resolvível", não uma consequência que a decisão pretenda abandonar caso a
		decomposição interna das invariantes do Registry evolua numa adoção futura.
		Isto NÃO é imunidade automática a upstream: mudança do schema adotado continua
		sendo ato governado de adoção, com verificação de compatibilidade. O predicado
		explícito apenas impede que a definição conceitual de resolução degenere em
		"active, seja lá o que isso venha a significar".

		(8) RESOLUÇÃO VÁLIDA = exact-ref ∧ active ∧ compatible-grant. As três condições
		são conjuntivas; qualquer uma ausente REJEITA. Sob o schema adotado ATUAL, o
		terceiro conjunto não recusa estado adicional algum (item 7) — a especificação
		permanece tri-conjuntiva; a redundância é propriedade factual documentada, não
		simplificação a fazer. Esta resolução é EXIGIDA de cada proofResult que satisfaz
		um requirement, somando-se (sem substituir) às invariantes de adr-188.

		(9) O REGISTRY CONSUMIDO PELO JOIN É TIPADO como #VerifierRegistry (ou a forma
		equivalente que o CUE exigir). Não se aceita parâmetro frouxo: é o compilador,
		não uma condição defensiva no predicado, que impede um chamador de passar um
		valor que não satisfaça as invariantes do Registry. Fixtures também constroem
		#VerifierRegistry VÁLIDO — testar estado irrepresentável pelo Registry seria
		teste de uma função hipotética diferente, não fixture de completion. A fronteira
		tipada não é flexibilizada para facilitar teste nem consumidor futuro.

		(10) UNICIDADE FAIL-CLOSED: a re-derivação DEPENDE do register-once já garantido
		pelo #VerifierRegistry (_uniqueRegister). Se por qualquer motivo a derivação
		produzir mais de um contrato para o mesmo (id, version), a resolução FALHA — não
		se escolhe arbitrariamente entre contratos ambíguos.

		(11) DECLARAÇÃO CANÔNICA DE CONSUMERHOOD. Todo consumidor governado desta
		resolução DECLARA consumerhood na FORMA CANÔNICA — o campo hidden
		_verifierResolutionConsumer, com valor que identifica inequivocamente o
		consumidor, ANINHADO na struct/definição desse consumidor. O placement aninhado
		NÃO é estilo: todos os .cue de governance/build-time/ formam um único package,
		e duas declarações top-level com valores distintos colidem em cue vet
		(conflicting values) — o segundo consumidor quebraria o build em vez de disparar
		o sensor. Verificado: aninhado, um consumidor, dois no mesmo arquivo e dois em
		arquivos distintos passam todos no cue vet, com a contagem esperada de
		declarações. A forma fechada (campo CUE, não substring solta) REDUZ a contagem
		incidental por tornar a declaração sintaticamente específica — não a elimina:
		uma linha que reproduza o token exato ainda conta para grep/re.findall. E a
		CONFORMIDADE de placement não é derivada semanticamente pelo sistema: corrigir a
		colisão não instaura enforcement universal de placement. A declaração
		exprime CONSUMERHOOD, não a sintaxe da re-derivação: refatorar a implementação
		não silencia a vigilância, e dois consumidores podem coabitar um arquivo sem
		cegar o sensor — a topologia do código não é ditada pelo detector.

		ENFORCEMENT E SEU LIMITE HONESTO. Três propriedades são distintas: (1)
		consumerhood REAL, (2) a DECLARAÇÃO canônica, (3) o TRIGGER que observa
		declarações. O gate determinístico
		scripts/ci/check-verifier-resolution-consumer-declaration.sh — required via
		verifier-registry-check.yml — fecha (1)→(2) com contrato ESTREITO e verdadeiro:
		arquivo em governance/build-time/ que use o IDIOMA ATUALMENTE CANÔNICO de
		re-derivação DEVE conter a declaração. Ele NÃO prova a norma universal: derivar
		(1) em geral é impossível — uma implementação futura que resolva verifier por
		outra construção é consumerhood real que nenhum detector sintático enxerga. E o
		enforcement completo ("exatamente uma declaração por consumidor") é
		INCONSTRUÍVEL por contagem, porque distinguir dois consumidores num arquivo de
		um consumidor com duas menções exige o mesmo conhecimento semântico de (1). A
		diferença entre a norma (universal) e a cobertura automática (idiom-bound) está
		registrada em ten-018 — não enterrada como observação.

		(12) NÃO DECIDE: nova superfície pública no Tekton; alteração do schema adotado;
		novo lifecycle; novos tipos de grant; verifier produtivo (o Registry permanece
		events: [], machine-first per adr-189 dec 6); admission (C3); e enforcement
		executor→autorização→append, que continua inexistente após C1.
		"""

	consequences: """
		Positivas.
		P1 — A fronteira de adr-189 dec 8 vira tipo: exact-ref ∧ active ∧
		compatible-grant é fail-closed em compile-time (cue vet -c), não norma escrita.
		Os estados que passam a ser recusados A MAIS são: verifier revogado, verifier
		deprecated, e digest (revision) divergente do contrato registrado. O conjunto
		compatible-grant NÃO entra nesta lista: sob o schema adotado atual ele é
		entailed pelo invariante C (decisão 7), logo não recusa estado adicional —
		declarado para não inflar o ganho incremental.
		P2 — Identidade forte preservada: a revision (digest) volta a ser load-bearing
		na resolução, não só na comparação requirement×result de adr-188.
		P3 — Autoridade única mantida: events continua o SoT; a re-derivação é leitura,
		não cópia — nenhuma segunda superfície de verdade nasce, e o schema adotado
		permanece verbatim (zero drift).
		P4 — C2 não fica refém de upstream: M-182 fecha sem depender de promoção ao
		Tekton; estender a projeção adotada segue candidata futura, sem bloquear.
		P5 — Fail-closed na ambiguidade: contrato duplicado para (id, version) rejeita em
		vez de escolher — o trust root não adivinha.

		Negativas.
		N1 — Acoplamento à FORMA do stream: a re-derivação lê o shape dos eventos
		"verifier-registered" do schema adotado. Se o upstream mudar essa forma, a
		re-derivação precisa acompanhar. Mitigado: a forma é fixada pelo schema adotado
		sob pin (adopted-artifacts) e mudança de upstream é ato governado de adoção.
		N2 — Lógica de resolução vive no consumidor, não na projeção: enquanto a
		extensão da projeção adotada não existir, cada consumidor futuro que precise
		resolver verifier repetiria esta derivação. Aceito para UM consumidor. Um SEGUNDO
		consumidor é o gatilho para CENTRALIZAR a resolução; só então se decide se a
		centralização permanece Mesh-local (abstração compartilhada aqui) ou se a
		universalidade justifica promoção ao Tekton — a localização da solução futura não
		é antecipada por este ADR. Registrado como deferimento consciente governado em
		def-085, com gatilho codificado (ver defersTo) em vez de prosa: o gatilho entra
		no runner determinístico e sobrevive entre sessões.
		N3 — Nada resolve em produção ainda: com events: [] nenhum requirement é
		satisfazível. Aceito e desejado — C2 entrega a máquina de resolução; o primeiro
		verifier real é decisão separada.
		"""

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se a re-derivação do contrato mínimo a partir de
			events não for suficiente para decidir exact-ref ∧ active ∧
			compatible-grant sem consultar estado privado do schema adotado, ou se
			resolver por essa via divergir do que a projeção do próprio Registry
			consideraria autorizado.
			"""
		observableSignal: """
			Um caso construível em que a resolução do join aceita um verifierRef que
			projection.lifecycle marca não-active ou cuja chave de grant não está em
			effectiveGrantKeys; ou a impossibilidade de obter revision/
			assertionSchemaRef de events sem acessar campo hidden.
			"""
	}

	affectedArtifacts: [
		"governance/build-time/task-spec-v2.cue",
		".github/workflows/verifier-registry-check.yml",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-085-verifier-resolution-shared-abstraction-home.cue",
		"architecture/tension-log/ten-018-consumerhood-norm-vs-idiom-bound-detection.cue",
		"scripts/ci/check-verifier-resolution-consumer-declaration.sh",
		"scripts/ci/tests/test_check_verifier_resolution_consumer_declaration.py",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: ["P0", "P10", "P12", "P14"]

	defersTo: ["def-085"]

	supersedes: []

	rationale: """
		P14 é o princípio central e a razão de C2 existir como tipo: a resolução é
		decidível a partir de dados presentes (o stream do Registry + o requirement),
		logo é invariante compile-time-forçada — não pode ser empurrada para runtime
		apenas porque "depende do Registry". adr-188 deferiu por ausência do Registry
		operacional; adr-189 entregou integridade causal, blocking real e autoridade
		declarativa; agora o deferimento perdeu a justificativa e a invariante desce
		para o tipo. P0 governa a escolha da re-derivação sobre as alternativas:
		localização canônica única — events é a fonte, a re-derivação é projeção de
		leitura, e o schema adotado não é editado (nenhuma cópia, nenhuma segunda
		autoridade). P10 fecha: quem valida é gate determinístico sobre o tipo; nenhum
		juízo estocástico decide se um verifier resolve. P12 entra pela declaração de
		consumerhood do item 11: a regra não fica como convenção — sobe para gate de CI
		required, seguindo o padrão adr-076 (quando a regra importa, o enforcement sobe
		para o CI). O resíduo que nenhum gate alcança — consumerhood por implementação
		fora do idioma conhecido — não é silenciado: está em ten-018, porque P12
		documentado-como-tensão é honesto, e P12 alegado-como-resolvido não seria.

		Alternativas rejeitadas. Estender a projeção pública do #VerifierRegistry para
		expor revision + assertionSchemaRef por versão exigiria editar o schema adotado
		verbatim (drift) ou promoção upstream ao Tekton, que bloquearia o fechamento de
		M-182 — permanece candidata futura, como o gap de terminalidade do adr-189 item
		7. Resolver apenas com a superfície pública atual (lifecycle "active" + alguma
		entrada em effectiveGrantKeys), sem exigir revision exata, enfraqueceria a
		identidade — dois digests distintos da mesma (id, version) resolveriam igual — e
		contradiz frontalmente adr-189 dec 8. Materializar a resolução sem ADR, como
		rationale do join, esconderia uma regra NOVA de identidade e trust resolution em
		comentário de schema.

		Trade-offs. A re-derivação custa acoplamento à forma dos eventos (N1) e lógica no
		consumidor (N2) — aceito pelos motivos acima. A unicidade fail-closed (dec 10)
		apoia-se no register-once já provado pelo schema adotado, sem reimplementá-lo: o
		join depende da propriedade, não a duplica. reversibility medium / blastRadius
		cross-artifact: o join V2 passa a depender semanticamente do Registry, mas nada
		produtivo consome (events: []), e admission (C3) segue fora.
		"""
}
