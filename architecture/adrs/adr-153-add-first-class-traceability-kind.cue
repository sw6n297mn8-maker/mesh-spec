package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-153 — Adiciona o kind structural-check `first-class-traceability`, o gate
// determinístico que materializa o enforcement (passos v–vi do D2 do adr-151) da
// rastreabilidade semântica first-class entre linguagem ubíqua e domain-model.
// UM kind único emite os 9 findings (G1–G5 Forma A owned + B1–B4 Forma B shared);
// o índice conceito↔termo é construído 1× (P0).
//
// status: accepted como BUNDLE (padrão kind-ADR adr-133, distinto do
// proposed-then-materialize do adr-151): ADR + enum-delta + evaluator + instância
// (enforcement:"warn") + worklist entram no MESMO PR atômico. O ADR afirma
// artefatos que existem no mesmo PR; `accepted` só é verdade com o bundle inteiro
// verde. A campanha subsequente (drenar a worklist via backfill Forma A; flip
// warn→reject) é faseada à parte, no estilo adr-151.

adr153: artifact_schemas.#ADR & {
	id:    "adr-153"
	title: "Adicionar kind first-class-traceability (gate de rastreabilidade do adr-151)"

	date: "2026-06-16"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "repo-wide"

	supersedes: []

	context: """
		ESTADO. O adr-151 estabeleceu a rastreabilidade semântica first-class entre a
		linguagem ubíqua (glossários de BC) e o domain-model — Forma A (conceito
		owned: firstClass + firstClassReason + coreNoun + termo dedicado) e Forma B
		(primitivo compartilhado: shared + canonicalSchemaRef + canonicalTermRef) — e
		materializou até o passo iv do seu D2: a extensão do canonicalPathRegex do
		#Glossary (Peça 1), o glossário-kernel com term-money (Peça 2), os campos no
		schema do domain-model (Peça 3a) e o backfill Forma B dos 4 vo-money apontando
		#Money/term-money (Peça 3b). Falta o ENFORCEMENT (passos v–vi do D2): hoje
		NADA obriga um conceito que cruza contrato a declarar a traceability. A
		varredura confirma o vácuo: 277 conceitos owned (agg/evt/cmd/vo) nos 12 BCs,
		ZERO declaram firstClass — a Forma A não foi backfillada.

		TRIGGER. Sem gate, a traceability é mantida por boa intenção — precisamente o
		que o adr-151 existe para não depender. O conceito central de um BC sem termo
		na linguagem (o gatilho original do adr-151: Payment no FCE) reaparece em
		silêncio enquanto a obrigação for cultural. O gate torna a obrigação imposta
		automaticamente no CI (P12), não lembrada por humanos.

		AMARRAÇÃO ao adr-151. Este ADR NÃO é decisão nova: materializa o passo v (gate
		em modo report) e prepara o passo vi (blocking) do D2 do adr-151. É o
		enforcement que o adr-151 desenhou em D1 (G1–G5 + fila de revisão como contrato
		do gate), agora portado para o structural-check-runner de produção — o gate.py
		dos pilotos provou o desenho, não é o artefato (D1 do adr-151).

		Alternativas avaliadas:
		(a) Kinds narrow, um por gate (1 kind por G1–G5/B1–B4) — REJEITADA: os 9 gates
		    compartilham o mesmo índice conceito↔termo e a mesma norm(); kinds narrow
		    reconstruiriam o índice 9× e duplicariam a lógica (drift por construção,
		    contra P0). Os gates são facetas de UMA verificação sobre o mesmo grafo
		    conceito-termo, não checks independentes — exceção justificada ao padrão
		    narrow do repo.
		(b) Gate direto em blocking (enforcement "reject") — REJEITADA: a Forma A não
		    foi backfillada (277 conceitos, 0 declarações); reject no dia um bloquearia
		    quase todo PR. Report-primeiro mede sem bloquear — a mesma lógica do
		    derived-drift-gate (adr-152) e do born-warn/catraca (adr-097): a casa é
		    coberta antes de o gate ligar.
		(c) Split ADR-vs-materialização (estilo adr-151) — REJEITADA para o KIND: kind
		    e evaluator são átomo por construção (evaluator-coverage/adr-099 exige os
		    dois no mesmo commit). O bundle num PR é o padrão de kind-ADR (adr-133,
		    adr-102/105/107). O split do adr-151 cabe à CAMPANHA (drenar a worklist,
		    flip warn→reject), que segue faseada — não ao átomo kind+evaluator.
		"""

	decision: """
		(1) ADICIONAR o kind first-class-traceability ao enum #StructuralCheckKind —
		    mais #FirstClassTraceabilityRule e a entrada na união discriminada de
		    #StructuralCheck. UM kind único que emite os 9 findings (G1–G5 da Forma A
		    owned + B1–B4 da Forma B shared); o índice conceito↔termo é construído 1× e
		    as 9 facetas leem dele (P0; decisão (a) acima).

		(2) IMPLEMENTAR o evaluator ev_first_class_traceability em
		    scripts/ci/structural-check-runner.py, registrado em EVAL, no MESMO COMMIT
		    do delta do enum — o evaluator-coverage (adr-099) exige evaluator para todo
		    kind declarado/usado ("cartaz sem fiscal é erro"). O evaluator porta a
		    lógica dos pilotos (norm() — minúscula+alfanumérico, igualdade EXATA — mais
		    pertinência de conjunto; zero heurística, zero LLM; P10) lendo o CUE real
		    (contexts/*/domain-model.cue + contexts/*/glossary.cue + o glossário-kernel),
		    não os JSON exportados que os pilotos liam.

		(3) CRIAR a instância #StructuralCheck em
		    architecture/structural-checks/first-class-traceability.cue com enforcement
		    "warn" (modo REPORT — acusa sem bloquear). O flip para "reject" é o passo vi
		    do adr-151, faseado (decisão (6)).

		(4) CRIAR o artefato-worklist
		    governance/build-time/first-class-backfill-worklist.cue (seed inicial):
		    allowlist de pendências reconhecidas, cada entrada {conceptCode, bc,
		    reason/wave, status}. O evaluator CONSULTA a worklist: um conceito que cruza
		    contrato sem firstClass é ACEITO se está na worklist (pendência reconhecida)
		    e ACUSADO se está fora (gap não-reconhecido). Isto resolve a
		    falsificationCondition 4 do adr-151 (pendente-reconhecido ≠ verde-falso) — e
		    é por isso que o artefato entra NO bundle, não na campanha: sem ele o
		    evaluator referenciaria arquivo ausente.

		(5) RESTRINGIR o escopo do G2 (classificação-forçada) a quem CRUZA CONTRATO. O
		    adr-151 (§1) define "cruza contrato" por membership em TRÊS artefatos —
		    port-manifest, assertion ou aggregate-manifest. A V1 do gate cobre o ÚNICO com
		    mapeamento determinístico hoje: aggregate-manifest (commandsAccepted /
		    eventsEmitted / aggregateRef → codes agg/cmd/evt; 4 BCs cmt/dlv/fce/rew;
		    invariants são alvos, não sujeitos do G2). Os outros DOIS triggers ficam
		    DEFERIDOS, cada um com razão e condição de revisita: (i) ASSERTION até def-049
		    materializar instâncias (formato/localização indefinidos hoje); (ii)
		    PORT-MANIFEST até existir mapeamento determinístico das suas value-class
		    canônicas (StreamId, AppendResult — grafia mesh-runtime) para vo- codes do
		    domain-model (deferimento governado em def-063) — mapear por aproximação de nome
		    violaria P10/norm()-exato e introduziria exatamente a categoria de erro que a
		    falsificationCondition deste ADR condena. Em todos os casos o gate verifica a
		    FRONTEIRA (o que o BC expõe), NÃO o INTERIOR (os 277 conceitos internos).

		(6) NÃO fazer neste PR (fasear): o backfill Forma A que drena a worklist e o
		    flip warn→reject (passo vi) são campanha subsequente. O def-062
		    (especialização local Forma B.2) permanece deferido — este gate cobre o caso
		    bkr pela Forma B com coreNoun divergente indo à fila, como o adr-151 previu.
		"""

	consequences: """
		Positivas.
		(1) A obrigação de traceability first-class passa de cultural a imposta no CI
		    (P12): o conceito-central-sem-termo — gatilho original do adr-151 (Payment
		    no FCE, último gate antes da primeira tela bancária) — não reaparece em
		    silêncio, porque a omissão de marcação para quem cruza contrato vira finding
		    de CI (G2).
		(2) Determinístico e reproduzível: norm() (igualdade exata) + pertinência de
		    conjunto, zero LLM (P10) — o mesmo regime estrutural do adr-040.
		(3) UM kind/evaluator, índice conceito↔termo construído 1× (P0): coeso, sem as
		    9 recomputações que kinds narrow imporiam.
		(4) Report-primeiro mede a dívida sem bloquear: a worklist quantifica a Forma A
		    pendente (a campanha drena uma fila visível, não um débito difuso).

		Negativas (honestas).
		N1 — FARDO FUTURO. Quando o flip warn→reject ocorrer (passo vi), todo conceito
		    novo que cruza contrato terá de declarar firstClass OU entrar na worklist —
		    fardo no autor. Mitigado: o ::error:: do gate nomeia o conceito a marcar. No
		    PR atual (enforcement "warn") não há fardo ainda — só medição.
		N2 — DEPENDÊNCIA DA WORKLIST. O gate só distingue pendência de gap se a worklist
		    for mantida honesta; uma worklist inflada (tudo enfileirado) esvaziaria a
		    distinção. Mitigado: allowlist revisável (review vê o que foi enfileirado) e
		    a drenagem (backfill Forma A) a reduz — inflá-la é visível, não silencioso.
		N3 — PORTE PILOTO→PRODUÇÃO. O evaluator lê o CUE real (domain-model + glossary),
		    não os JSON dos pilotos; a fidelidade da lógica portada à estrutura viva
		    (shared:false defaulted, opcionais ausentes, os markers da 3a) é pressuposto.
		    Mitigado: validação na materialização (o report inicial deve bater com a
		    estimativa) e os três pilotos que provaram o desenho contra o enforcer real.
		"""

	falsificationCondition: {
		condition: """
			O adr-153 estaria errado se o gate produzisse findings que não correspondem
			a gaps reais (falso-positivo: acusar um conceito que JÁ declara firstClass
			com termo dedicado, ou que JÁ está na worklist) OU silenciasse gaps reais
			(falso-negativo: um conceito que cruza contrato, sem firstClass e fora da
			worklist, passando verde). Qualquer um dos dois provaria que o gate dá falsa
			confiança — o medo dominante do adr-151 (falsificationCondition 4).
			"""
		observableSignal: """
			O report de first-class-traceability acusando um conceito comprovadamente
			coberto (declara firstClass com termo dedicado, ou consta na worklist), ou
			passando verde um conceito que cruza contrato (membership nas fontes de
			cruza-contrato per decisão (5)) sem firstClass e ausente da worklist.
			"""
	}

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue", // enum #StructuralCheckKind + #FirstClassTraceabilityRule + união discriminada
		"scripts/ci/structural-check-runner.py",              // evaluator ev_first_class_traceability + registro em EVAL
	]

	plannedOutputs: [
		"architecture/structural-checks/first-class-traceability.cue", // instância #StructuralCheck enforcement:"warn"
		"governance/build-time/first-class-backfill-worklist.cue",     // worklist seed (allowlist de pendências reconhecidas)
	]

	// derivedArtifacts: omitido — o gate LÊ (domain-model + glossary); não gera
	// nenhum artefato derivado como consequência.

	// Deferimento governado criado por esta decisão (per adr-062): o trigger
	// port-manifest do G2 (decisão 5). def-049 (assertion) é ref em prosa — não é
	// criado por este ADR, então fora de defersTo.
	defersTo: ["def-063"]

	principlesApplied: [
		"P0 — localização canônica única: UM kind/evaluator constrói o índice conceito↔termo 1× e as 9 facetas (G1–G5+B1–B4) leem dele; kinds narrow recomputariam e duplicariam a lógica (drift por construção).",
		"P10 — gates determinísticos validam, agentes recomendam: G1–G5+B1–B4 validam ESTRUTURA via norm() exato + pertinência de conjunto (zero LLM); a verdade semântica (masquerade 4e, firstClass:false honesto) fica com o humano/self-review — a linha que o non-goal do adr-151 protege.",
		"P12 — governança-como-código: a omissão de cobertura para quem cruza contrato vira finding de CI (G2), não lembrete em documento.",
		"adr-151 — materializa os passos v (gate report) e vi (blocking, faseado) do D2; este gate é o enforcement que o adr-151 desenhou em D1 (G1–G5 + fila como contrato), portado do gate.py dos pilotos para produção.",
		"adr-099 — evaluator-coverage: o kind e o evaluator entram no MESMO commit (cartaz sem fiscal é erro), razão pela qual o bundle é atômico e não admite o split do adr-151.",
	]

	rationale: """
		A camada de linguagem ubíqua ganha a maquinaria de governança que a camada de
		schema já tem (#Money + família shared-types): cada conceito de primeira classe
		que cruza contrato passa a ter elo verificável por máquina ao domain-model, em
		vez de depender de boa intenção — a mesma disciplina que a Mesh aplica ao risco,
		aplicada à própria linguagem do sistema. Sem este gate, o adr-151 seria desenho
		sem enforcement: os campos existem (Peça 3a) e o kernel existe (Peça 2), mas nada
		obriga seu uso.

		Por que kind único (não narrow): os 9 gates são facetas de UMA verificação sobre
		o mesmo grafo conceito↔termo; o índice é construído 1× (P0). Por que bundle (não
		split estilo adr-151): kind e evaluator são átomo por evaluator-coverage
		(adr-099) — declarar o kind no enum sem o evaluator falha o próprio meta-check; o
		split do adr-151 cabe à CAMPANHA (drenar a worklist, flip warn→reject), não ao
		átomo. Por que warn (não reject): a Forma A não foi backfillada (277/0); reject no
		dia um afogaria o sinal — born-warn/catraca (adr-097), a casa coberta antes de
		ligar, como o derived-drift-gate (adr-152). Por que escopo G2 estreito: o "default
		proibido" do adr-151 vale para quem CRUZA CONTRATO (a fronteira que outros BCs
		consomem), não para a modelagem interna — verificar o interior dos 277 seria gate
		sobre decomposição local, fora do contrato do adr-151.

		reversibility "medium": reverter é remover o kind+evaluator+instância+worklist —
		migração mecânica (o gate não persiste estado nem altera contrato de domínio), não
		reescrita. blastRadius "repo-wide": o evaluator roda em todo PR via
		structural-check-runner, e o enum do #StructuralCheckKind é consumido repo-wide.

		Tensão com axiomas: nenhuma. O deferimento da Forma B.2 (def-062) e o faseamento
		do flip warn→reject (campanha) são known-gaps governados com condição de revisita,
		não tensões.
		"""
}
