package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr191: artifact_schemas.#ADR & {
	id:    "adr-191"
	title: "Centralizar a resolução de identidade de verifier numa abstração Mesh-local"
	date:  "2026-08-11"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "high"
	blastRadius:   "cross-artifact"

	context: """
		Estado precedente. adr-190 fixou a resolução de identidade de verifier para
		completion V2 (exact-ref ∧ active ∧ compatible-grant, re-derivada do stream
		público do Registry) e C2 a materializou DENTRO do consumidor — a
		comprehension _resolvableRefKeys inline em #TaskCompletionV2
		(governance/build-time/task-spec-v2.cue). def-085 deferiu conscientemente a
		pergunta "onde vive a abstração compartilhada?" até surgir um segundo
		consumidor, com par de triggers contando declarações canônicas de
		consumerhood (threshold 2) e seis limitações declaradas. ten-018 registrou a
		tensão: a norma de consumerhood é semântica, a cobertura automática é
		idiom-bound. O gate check-verifier-resolution-consumer-declaration.sh
		(wired em verifier-registry-check.yml, workflow required per adr-189)
		enforça a declaração para o idioma canônico de re-derivação.

		Trigger. O desenho de C3 (admission born-reject, prometida por adr-188 item
		6 e adr-189) estabeleceu o SEGUNDO consumidor da resolução: o
		#TaskAdmissionV2 Mesh deve exigir que todo verifierRef declarado resolva
		pela MESMA definição usada na completion. O precedente upstream
		(tekton-spec adr-009, #TaskAdmissionV2 em governance/build-time/
		work-governance.cue) verifica (id, version) ativo — sem revision; o check
		explícito de grant é entailed por active nos dois lados (adr-190 dec 7), de
		modo que o delta REAL de poder de rejeição é a revision. Esse delta basta
		para o problema: um digest divergente seria admissível pelo predicado
		upstream e impossível de completar pela completion Mesh — duas semânticas
		de confiança, não duplicação de código. E duplicar a comprehension no
		admission tornaria factual a decisão deferida em def-085 antes de
		resolvê-la. Decisão do founder (2026-08-11): reconhecer o segundo
		consumidor no design, resolver def-085 agora, centralizar Mesh-local.

		Descoberta de prototipagem (cópia isolada, verificada por execução). (i)
		Centralizar INVERTE o gate de consumerhood: o idioma de re-derivação migra
		para o arquivo da abstração (que não é consumidor) e sai do consumidor (que
		permanece consumidor sem carregar o idioma) — o gate atual sai 1 nomeando
		verifier-resolution.cue. O re-apontamento do detector é, portanto, parte
		inseparável da centralização, não follow-up. (ii) Os sensores de def-085
		contam DECLARAÇÕES (limitação iv do próprio def): a condição semântica do
		deferimento — existe segunda necessidade de consumo — tornou-se verdadeira
		no DESIGN antes de o proxy automatizado poder observar 2 >= 2; o disparo
		mecânico exigiria materializar a segunda declaração, que é exatamente o que
		não se faz antes de resolver a morada. (iii) Hidden em CUE é
		PACKAGE-SCOPED: um probe no mesmo package build_time acessa
		_resolvableRefKeys e passa cue vet — a fronteira de API interna não é
		imponível pelo compilador dentro do package (ver dec 4 e R3).

		Alternativas avaliadas: (a) duplicar a comprehension no admission —
		rejeitada: cria a segunda cópia da mesma regra de identidade cujo risco de
		divergência silenciosa é o custo que def-085 registrou, e torna a decisão
		deferida factual sem resolvê-la; (b) adotar o #TaskAdmissionV2 do tekton
		verbatim — rejeitada: importa o predicado sem revision e produz tarefa
		admissível por uma semântica e impossível de completar pela outra; (c)
		promover a abstração ao Tekton agora — rejeitada: dois consumidores provam
		necessidade de CENTRALIZAÇÃO, não universalidade; Mesh-local primeiro,
		promoção quando houver evidência (a distinção que def-085 codificou); (d)
		registrar estado 'triggered' sintético antes de resolver — rejeitada: o
		runner nunca observou 2 >= 2; gravar 'triggered' atribuiria ao mecanismo
		uma observação que ele não fez, corrompendo a distinção condição-real ×
		sensor.
		"""

	decision: """
		(1) ESCOPO: exclusivamente a centralização da resolução de identidade de
		verifier numa abstração Mesh-local, com os re-apontamentos de enforcement e
		vigilância que ela exige. Nada além.

		(2) CRIAR #VerifierResolution em governance/build-time/
		verifier-resolution.cue: função declarativa PURA — (registry, refs) →
		resolvability —, sem estado próprio, sem cache normativo, sem projeção
		persistida. O Registry permanece o ÚNICO SoT (adr-190 dec 2 inalterada); a
		abstração é leitura sobre o stream, não segunda autoridade nem novo trust
		root.

		(3) REGISTRY TIPADO: registry!: #VerifierRegistry (adr-190 dec 9). O
		register-once continua garantido POR TIPO (_uniqueRegister; adr-190 dec
		10) — a abstração depende da propriedade, não a reimplementa.

		(4) FRONTEIRA DE API: a superfície pública é resolve {refs!:
		[...#VerifierRef], out} — consumidor fornece refs, abstração devolve
		resolvability. _resolvableRefKeys (representação por chave string) e o
		helper de serialização são INTERNOS por norma. HONESTIDADE DO MECANISMO:
		hidden em CUE é package-scoped — dentro de build_time o compilador NÃO
		impede o acesso (verificado por execução: probe no mesmo package passa cue
		vet). A fronteira é normativa; seu enforcement mecânico é a regra R3 do
		detector (dec 7). Se a representação interna de identidade mudar no
		futuro, consumidores conformes não mudam.

		(5) O helper de serialização _#refKey é DEFINIÇÃO hidden (template
		privado), NÃO hidden field. Motivo verificado por execução NESTA
		prototipagem: cue vet -c não reporta incompletude de hidden field (mesma
		família do bypass de hidden field registrado em adr-062, N5), enquanto
		definição hidden é silenciosa POR DESENHO — template não exige concretude.
		A API não se apoia em ponto cego. Serializar #VerifierRef como string não
		é capability pública do Mesh — e, pela mesma honestidade do item 4, isso é
		norma com R3, não impossibilidade de compilador.

		(6) MIGRAR #TaskCompletionV2 para consumir resolve(), sem mudança
		semântica — provado: ContractGate 8/8 pré e pós-migração, com as mesmas
		atribuições de camada (4 negativos rejeitados pelo join, 2 pela camada
		Registry). A NORMA da declaração canônica _verifierResolutionConsumer:
		aninhada (adr-190 item 11) segue em vigor; o CONTRATO DE ENFORCEMENT
		descrito naquele item é re-apontado por este ADR (dec 7) — "integralmente
		em vigor" valeria só para a metade normativa, e é assim que deve ser lido.

		(7) RE-APONTAR o detector de consumerhood
		(scripts/ci/check-verifier-resolution-consumer-declaration.sh), wired no
		workflow required verifier-registry-check.yml, com TRÊS regras: (R1)
		consumidor reconhecível = instanciação/unificação com #VerifierResolution
		em linha não-comentada → DEVE carregar a declaração canônica; o arquivo
		que DEFINE a abstração não é consumidor; menção em comentário não conta.
		(R2) ANTI-BYPASS DO IDIOMA: a comprehension crua filtrando eventos
		"verifier-registered" em governance/build-time/ FORA de
		verifier-resolution.cue é VIOLAÇÃO — após a centralização, re-derivar fora
		da abstração é bypass da localização canônica (P0), não consumerhood
		legítima. (R3) ANTI-BYPASS DE INTERNALS: o token _resolvableRefKeys em
		linha não-comentada FORA de verifier-resolution.cue é VIOLAÇÃO — fecha,
		com detector textual explícito, o acesso que o package-scope de CUE não
		impede (dec 4). O detector antigo não é descartado: muda de "exigir
		declaração" para "exigir declaração de quem consome + proibir bypass".
		[R2 e R3 são adições do agente ao envelope aprovado pelo founder —
		trazidas explicitamente para decisão; dec 9, consequência P2 e o rationale
		as assumem e serão reescritos se forem rejeitadas.] A suite do detector
		prova o novo contrato ANTES do commit — mesmo padrão de evidência do
		ContractGate; o re-apontamento acontece no MESMO commit da centralização.

		(8) def-085: open → resolved DIRETO, resolvedBy = este ADR.
		triggeredCondition registra que a condição semântica (segunda necessidade
		de consumo) foi estabelecida pela decisão de design de C3 ANTES de o proxy
		automatizado poder observá-la — condição real e sensor são coisas
		distintas, e o registro preserva a distinção. NÃO se grava estado
		'triggered' sintético. Os triggers permanecem no artefato como registro
		histórico do mecanismo e da calibração, SEM função normativa
		pós-resolução; NÃO são reinterpretados como sensor de promoção upstream.

		(9) ten-018 ATUALIZADA e PERMANECE open: o proxy de detecção migra de
		"idioma incidental da implementação" para "uso da abstração canônica" —
		redução material do risco (instanciar um tipo nomeado é difícil de
		reproduzir por acidente; bypass do idioma e de internals viram violação
		por R2/R3) — mas o detector segue TEXTUAL: não deriva consumerhood
		semanticamente do grafo de tipos/imports. A tensão muda de natureza e
		diminui; não morre.

		(10) NÃO DECIDE: promoção da abstração ao Tekton; o #TaskAdmissionV2 Mesh
		(C3b); mandatoryVerifiers no #TaskTemplate local (C3b); e, explicitamente:
		"quantidade futura de consumidores como critério de promoção upstream" NÃO
		é responsabilidade residual de def-085 — se essa pergunta merecer
		vigilância automatizada, nasce como def novo, com trigger próprio, sem
		carregar semântica residual do def resolvido.
		"""

	consequences: """
		Positivas.
		P1 — UMA trust semantics para consumidores CONFORMES: completion consome a
		única abstração canônica #VerifierResolution; quando C3b materializar o
		admission, ele consumirá a mesma definição, e a equivalência
		admission↔completion será estrutural, não propriedade testada por
		espelhamento de fixtures. R2 e R3 tornam bloqueantes os DOIS bypasses
		conhecidos — re-derivação pelo idioma canônico e acesso direto aos
		internals — sem alegar detecção semântica universal de toda implementação
		alternativa (é exatamente por isso que ten-018 segue open).
		P2 — Detector com alvo materialmente melhor: uso de tipo nomeado (R1) +
		proibição do bypass pelo idioma conhecido (R2) e por acesso a internals
		(R3). A cópia divergente da comprehension — o modo de falha que def-085
		previu — deixa de depender de disciplina e passa a ser barrada por gate no
		workflow required.
		P3 — def-085 fecha com governança honesta: a distinção condição-real ×
		sensor fica registrada no próprio artefato, precedente para deferimentos
		cuja condição semântica precede o proxy automatizado.
		P4 — Reversível: desfazer é re-inlinear a comprehension nos consumidores;
		nenhuma informação é criada ou perdida na centralização.

		Negativas.
		N1 — Indireção: quem lê o join não vê mais a regra inline; lê resolve() e
		precisa seguir o ponteiro. Mitigada pela documentação no arquivo da
		abstração e pelos ponteiros adr-190/adr-191 nos comentários.
		N2 — O detector novo é tão textual quanto o antigo: consumerhood por
		construção desconhecida segue invisível (por isso ten-018 permanece open).
		A melhora é de alvo e de cobertura do caminho conhecido, não de categoria.
		N3 — Ponto único de mudança: um erro na abstração propaga a TODOS os
		consumidores de uma vez. Aceito — é o trade-off constitutivo de qualquer
		centralização P0, e o caminho está coberto por ContractGate + suites; a
		alternativa (cópias independentes) troca este risco visível por divergência
		silenciosa, que é pior.
		"""

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se a abstração não conseguir servir um
			consumidor governado real sem mudança semântica ou sem vazar internals —
			p.ex., se o #TaskAdmissionV2 de C3b precisar acessar _resolvableRefKeys
			diretamente, ou re-derivar o idioma cru, para expressar seu predicado.
			"""
		observableSignal: """
			R2/R3 vermelhas para os bypasses CONHECIDOS num consumidor governado que
			precisou deles para funcionar; OU divergência de veredito entre dois
			consumidores sobre o mesmo (registry, verifierRef) encontrada por
			fixture/teste COM R2 e R3 verdes — este segundo caso é evidência de que
			surgiu uma forma de bypass que os detectores textuais não conhecem
			(detector incompleto), não de que a divergência é impossível.
			"""
	}

	affectedArtifacts: [
		"governance/build-time/task-spec-v2.cue",
		"scripts/ci/check-verifier-resolution-consumer-declaration.sh",
		"scripts/ci/tests/test_check_verifier_resolution_consumer_declaration.py",
		".github/workflows/verifier-registry-check.yml",
		"architecture/deferred-decisions/def-085-verifier-resolution-shared-abstraction-home.cue",
		"architecture/tension-log/ten-018-consumerhood-norm-vs-idiom-bound-detection.cue",
	]

	plannedOutputs: [
		"governance/build-time/verifier-resolution.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: ["P0", "P10", "P12", "P14"]

	defersTo: []

	supersedes: []

	rationale: """
		P0 é o motor. Duas cópias da mesma regra de identidade seriam exatamente a
		segunda autoridade que a localização canônica única proíbe; com o segundo
		consumidor estabelecido no design de C3, a re-derivação per-consumidor
		deixou de ser aceitável, e a centralização Mesh-local é o MENOR movimento
		que restaura a unicidade — sem promover ao Tekton antes de a universalidade
		ser provada, que é a distinção que o próprio def-085 codificou. P12 governa
		os re-apontamentos: a regra que importa (consumidor declara; bypass é
		violação) não fica como convenção — o detector muda de alvo no MESMO commit
		da centralização, e a suite do detector prova o novo contrato antes do
		commit, para que não exista nem janela vermelha (commit deliberadamente
		quebrado) nem janela silenciosa (gate cego ao novo mundo). P10: quem valida
		a resolvability segue sendo gate determinístico sobre tipos; nenhum juízo
		estocástico participa. P14: a invariante permanece compile-time, e a
		preservação de semântica na migração não é presumida — é provada pelo
		ContractGate (8/8, mesmas camadas de rejeição). Onde o compilador
		comprovadamente NÃO alcança (hidden package-scoped, dec 4), a regra não é
		alegada como tipo: é rebaixada a norma com detector textual explícito (R3)
		— P14 honesto em vez de P14 fingido.

		Metadata de risco. reversibility high: a decisão move a MORADA de uma regra
		já provada, não a regra — desfazer é re-inlinear mecanicamente; nada
		persistido, nenhum contrato público (Registry segue events: []).
		blastRadius cross-artifact: a decisão toca dois schemas (#VerifierResolution
		criado, #TaskCompletionV2 migrado) e re-aponta enforcement — múltiplos
		artefatos do mesmo contexto de governança, per taxonomia do #ADR; "local"
		falharia tq-adr-02 pela própria definição (1 artefato ou 1 schema).

		Trade-offs. N1 (indireção) e N3 (ponto único) aceitos como custo
		constitutivo de centralização; N2 mantém ten-018 open — o que este ADR
		entrega é o structuralResolutionPath da tensão amadurecendo: consumidor
		passa a ser "quem referencia/instancia a abstração canônica" — que é
		exatamente o que R1 observa. Dentro de um mesmo package não há grafo de
		imports a derivar; a derivação SEMÂNTICA de consumerhood (grafo de tipos)
		segue não alcançada, e é ela que fecharia a tensão.
		"""
}
