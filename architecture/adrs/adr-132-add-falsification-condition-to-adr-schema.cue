package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr132: artifact_schemas.#ADR & {
	id:    "adr-132"
	title: "Adicionar falsificationCondition ao schema #ADR"

	date: "2026-05-30"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		PR-#1 da sequência de feedback-cycles. A auditoria de ciclos de feedback
		(session:feedback-cycles-audit) mapeou 3 ciclos de build-time + 3 camadas
		de sistema e identificou a Camada 2 — "ADR como hipótese falsificável" —
		como ausente: hoje o #ADR (architecture/artifact-schemas/adr.cue) registra
		a decisão, a metadata de risco (reversibility, blastRadius), o deferimento
		(defersTo) e a sucessão (supersededBy), mas NÃO tem onde registrar "esta
		decisão estará errada SE X". Sem isso, não há ciclo de feedback de médio
		prazo sobre se a modelagem ainda está certa — a decisão é revisitada só
		quando algo quebra, não quando uma condição observável a invalida.

		O gap foi registrado em def-032 (deferred-decision, criado em #93). A
		decisão de adicionar o campo já estava tomada na auditoria com o founder;
		def-032 registrou o gap por completude e rastreabilidade, com horizonte
		de resolução iminente (este PR).

		Alternativas avaliadas:

		(a) Caminho C — adicionar AGORA um novo structural-check kind
		    (conditional-required-block por decisionClass) para gate-ar o
		    preenchimento, faseado warn→reject. REJEITADA neste PR: nenhum kind
		    existente condiciona por decisionClass ou por filename, logo o gate
		    exigiria evoluir o motor de checks (novo #StructuralCheckKind + handler
		    no runner) — uma segunda evolução de schema, repo-wide, aninhada num PR
		    cujo núcleo é adicionar um campo. Repete o anti-pattern que o arco
		    cycle-resolution evitou: cada kind novo foi seu próprio PR (adr-102
		    cross-file-id-exists, adr-105 scoped-cross-file-id-exists, adr-107
		    regex-pattern-match). O gate merece PR dedicado e permanece deferido em
		    def-032.

		(b) Caminho B — tornar o campo obrigatório para decisionClass=structural
		    via uma segunda união discriminada (status × decisionClass) no #ADR,
		    gate em tempo de cue vet. REJEITADA: perde o phasing "opcional no
		    rollout, depois obrigatório" que o próprio def-032 pede (cue vet é
		    binário, sem estágio warn), força backfill imediato dos 6 ADRs
		    structural, e multiplica a complexidade da união fechada.

		(c) Shape string livre (campo único de texto). REJEITADA: falsification
		    Condition é o primeiro campo VERIFICÁVEL do #ADR (não meramente
		    descritivo como context/decision/consequences); deixar o sinal
		    observável como prosa solta convida ao vago. Uma struct com
		    observableSignal explícito força a disciplina estruturalmente.

		(d) Backfill de todos os ADRs structural (6) ou de todos os ADRs.
		    REJEITADA: def-032 nomeia 127/129/131 (derivação de fronteira de BC)
		    como os que mais se beneficiam — a fronteira de um BC É a hipótese, e o
		    teste de remoção P13 já fornece a condição de falsificação natural.
		"""

	decision: """
		(1) ADICIONAR ao #ADRBase o campo OPCIONAL
		    falsificationCondition?: #FalsificationCondition, sub-tipo struct
		    mínimo {condition: string & !="", observableSignal: string & !=""}.
		    condition declara "esta decisão estará errada SE ___"; observableSignal
		    nomeia o sinal verificável que evidencia a condição (structural-check,
		    contagem de evento, gate de CI). Declarado em #ADRBase — não na união
		    discriminada por status — porque struct fechada CUE não admite novos
		    campos via união (mesma razão arquitetural de supersededBy, já
		    documentada no schema).

		(2) MANTER o campo OPCIONAL e NÃO introduzir gate/enforcement neste ADR. O
		    structural-check condicional por decisionClass (faseado warn→reject)
		    permanece DEFERIDO sob def-032, que continua "open". Este ADR entrega a
		    base estrutural (o campo), não o enforcement.

		(3) FAZER BACKFILL de falsificationCondition apenas nos 3 ADRs de derivação
		    de bounded context — adr-127 (FCE), adr-129 (DRC), adr-131 (SCF) — cada
		    condition derivada do teste de remoção P13 do BC ("o que tornaria esta
		    derivação errada?"). ADRs structural não-derivação (adr-126, adr-128,
		    adr-130) ficam lazy (campo opcional, sem backfill); ADRs adr-001..125
		    permanecem intocados.

		(4) DOGFOODING: este ADR carrega sua própria falsificationCondition — é o
		    primeiro ADR a usar o campo que adiciona.

		(5) NÃO RESOLVER def-032 com este ADR. A leitura do texto de def-032
		    (description + deferralRationale) amarra a resolução ao gate: o
		    deferralRationale enumera o bundle deferido como "evolução do schema
		    #ADR + structural-check + migração", e o structural-check não é
		    entregue aqui. Logo def-032 permanece "open" e nenhum def-035 é criado
		    — o gate continua sendo conteúdo canônico de def-032.
		"""

	consequences: """
		Positivas:
		(P1) A Camada 2 do ciclo de feedback de médio prazo passa a ser expressável
		     a nível de schema: todo ADR futuro PODE registrar a condição
		     observável que o invalida, tornando a decisão revisitável sem reabrir
		     toda a análise.
		(P2) Os 3 ADRs de derivação de BC (127/129/131) ganham hipótese falsificável
		     ancorada no teste de remoção P13 — o teste que decide a fronteira passa
		     a carregar seu gatilho de invalidação explícito (e.g., surgimento de
		     aresta reversa monitorável por sc-cm-07).
		(P3) Distinção semântica explícita no schema: falsificationCondition
		     (gatilho que invalida) ≠ reversibility (custo de reverter) ≠ defersTo
		     (deferimento) ≠ supersededBy (sucessão).
		(P4) PR de classe única (campo + backfill), sem aninhar evolução do motor de
		     checks — reversível com esforço moderado e auditável.

		Negativas:
		(N1) Sem gate determinístico agora, o preenchimento do campo depende de
		     disciplina (PG-ADR + founder review) até def-032 materializar o
		     structural-check — risco de campos genéricos ou ausentes em ADRs novos.
		     Mitigação: backstop recurrence de def-032 (dispara no 5º ADR derive-*;
		     N=3 hoje).
		(N2) def-032 permanece "open" com a sua 1ª cláusula (adicionar o campo) de
		     fato satisfeita — leve dissonância entre o texto do DD e seu estado; o
		     escopo vivo de def-032 estreita para o gate. A description de def-032
		     não é reescrita (seria mudança semântica fora do escopo deste PR).
		(N3) falsificationCondition é o primeiro campo estruturado "rico" (não
		     string livre) do #ADR — leve desvio do idiom dos demais campos; se
		     def-034 (painel de métricas) exigir shape diferente, há risco de
		     retrabalho. Mitigação: struct mínima de 2 campos, sem otimizar para o
		     painel ainda.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			Esta decisão (adicionar falsificationCondition como campo opcional, com
			o gate deferido) estará errada SE o campo virar ritual — ADRs
			preenchendo condition/observableSignal genéricos e não-verificáveis
			(prosa em vez de sinal observável) — OU se o gate condicional deferido
			em def-032 nunca materializar E nenhum ADR de derivação adotar o campo
			voluntariamente (campo opcional ignorado na prática).
			"""
		observableSignal: """
			Auditoria periódica dos ADRs que carregam falsificationCondition: razão
			entre observableSignal mapeável a um mecanismo concreto (structural-
			check, contagem de evento, gate de CI) vs. prosa vaga; adoção voluntária
			do campo em ADRs derive-*-bounded-context antes do gate; e o estado de
			def-032 (open ⇒ gate ainda ausente; resolved ⇒ enforcement fechou o
			ciclo).
			"""
	}

	affectedArtifacts: [
		"architecture/artifact-schemas/adr.cue",
		"architecture/adrs/adr-127-derive-fce-bounded-context.cue",
		"architecture/adrs/adr-129-derive-drc-bounded-context.cue",
		"architecture/adrs/adr-131-derive-scf-bounded-context.cue",
	]

	principlesApplied: ["P12", "P10", "P0"]

	supersedes: []

	rationale: """
		P12 (governança é código): falsificationCondition materializa a base sobre
		a qual a fitness function de "a decisão ainda está certa?" se torna
		codificável. O campo é o pré-requisito estrutural; o gate (a fitness
		function determinística) é a fase deferida em def-032. Adicionar a base sem
		o gate é deliberado — entrega valor (a hipótese explícita) sem aninhar a
		evolução do motor de checks.

		P10 (agentes estocásticos recomendam, gates determinísticos validam):
		observableSignal é exatamente o sinal que um gate determinístico futuro
		inspeciona. Manter o campo como registro (recomendação) e NÃO acoplar
		enforcement estocástico a ele preserva a separação P10 — o enforcement,
		quando vier, será determinístico (um structural-check), não interpretação
		de LLM sobre prosa.

		P0 (uma localização canônica): a hipótese falsificável de um ADR vive no
		próprio ADR (o campo), não duplicada em outro artefato — coerente com
		reversibility/defersTo/supersededBy como dimensões distintas registradas no
		mesmo lugar.

		Por que opcional + gate deferido (não Caminho C): aninhar um novo
		structural-check kind num PR de adição de campo repete o anti-pattern que o
		arco cycle-resolution evitou (cada kind = adr-102/105/107 próprio); o blast
		radius de um kind novo é repo-wide (afeta o motor de todos os checks) e
		merece PR dedicado. def-032 continua o lar canônico desse gate; sua
		resolução virá no PR do gate, não neste.

		Por que struct (não string): é o primeiro campo verificável do #ADR;
		observableSignal como subcampo força a condição a apontar para algo
		inspecionável (um mecanismo Mesh — structural-check, contagem de evento,
		gate de CI), disciplina que uma string livre não garante.

		Por que backfill só nas derivações: def-032 nomeia 127/129/131 como os que
		mais se beneficiam — a fronteira de um BC é a hipótese de design, e o teste
		de remoção P13 (se remover o BC e o resto parar por acoplamento, a fronteira
		está errada) fornece a condition natural. As conditions backfilladas são
		inversões diretas de cada teste de remoção, com observableSignal ancorado em
		sc-cm-07 (acyclicity, catraca adr-123) e contagens de eventos do BC.

		def-032: a leitura de description + deferralRationale amarra a resolução ao
		gate (o structural-check faz parte do bundle deferido); este ADR não o
		entrega, então def-032 permanece "open" e nenhum def-035 é criado. defersTo
		não é usado porque def-032 pré-existe (defersTo registra deferimentos que o
		ADR cria) — a relação é documentada aqui em prosa.

		Tensão com axiomas: nenhuma.
		"""
}
