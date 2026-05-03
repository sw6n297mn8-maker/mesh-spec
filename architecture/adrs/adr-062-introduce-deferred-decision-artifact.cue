package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr062: artifact_schemas.#ADR & {
	id:    "adr-062"
	title: "Introduce #DeferredDecision artifact type para deferimentos conscientes governados"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Sessão 2026-05-03 (claude/resume-mesh-work-jv2MC) materializou
		padrão recorrente: ao escolher entre opções com cobertura
		parcial vs completa (e.g., WI-068 Opção B com 1 novo
		structural-check kind vs Opção C com 3), o sistema acumulou
		dívida tecnicamente registrada apenas em prose ("Known gaps
		declarados" em ADRs como adr-047, adr-061). Evidências do gap:

		(a) ADRs antigas têm "Known gaps declarados" como section
		prosaica não-queryable. adr-047 lista gaps em api-spec coverage;
		adr-061 lista gaps em consumidores de #ArtifactType estendido.
		Identificação manual via grep, sem trigger automático.

		(b) Projeções derivadas de work-events (governance/build-time/
		projections/) ficam stale: ready-queue.cue rebuilt 2026-03-28,
		blocked-items.cue + in-progress.cue rebuilt 2026-03-22 — drift
		de 5+ semanas. WIs em status task-approved sem SLA acumulam
		(29 atualmente em stale state).

		(c) Tension-log existe (architecture/tension-log/) mas semântica
		é design-conflict, não trabalho-deferido (vc-te-01 do prompt
		validate-tension-entry captura: bug/gap travestido NÃO é tensão).
		Misclassificação produz log poluído.

		(d) WIs (governance/build-time/task-specs/) são para trabalho a
		executar, sem condicional codificada de revisita. WI em status
		task-approved sit indefinidamente (29 hoje); deferimentos com
		trigger natural ("revisitar quando X") não têm onde viver.

		Founder requirement explícito (sessão 2026-05-03): "antes de
		escolher Opção B, vamos criar a máquina de cobrar as dívidas.
		Me dê uma proposta de design que seja automática, e que resolva
		definitivamente esse tipo de problema". Bloqueio em série de
		WIs que escolheriam cobertura parcial (WI-068 Opção B é caso
		imediato) até máquina existir.

		Alternativas consideradas e rejeitadas:

		(a) Estender #ADR com section "deferredItems" como sub-tipo
		estruturado (vs prose Known gaps). Rejeitada: ADR é decisão
		tomada, não decisão de não-decidir. Lifecycle de deferimento
		(open → triggered → resolved/withdrawn) é fundamentalmente
		distinto do lifecycle de ADR (proposed → accepted → superseded).
		Misturar dilui ambos. Reuso de ADR reversibility/blastRadius
		via composição é pequeno benefício comparado ao custo de mistura
		conceitual.

		(b) Estender #TensionEntry com subkind "deferred-work". Rejeitada:
		vc-te-01 (já materializado em validate-tension-entry deste
		commit-anterior) explicita 'bug/gap classificável como WI →
		deveria ser WI, não tension'. Adicionar subkind 'deferred-work'
		ao tension-entry contradiz disciplina do próprio prompt.

		(c) Discipline prosaica + revisão periódica do founder sem novo
		artifact type. Rejeitada: padrão atual (Known gaps em ADRs +
		manual review) provadamente falha — projections stale 5+
		semanas, gaps em prose não-queryable, sem trigger automático.
		Founder explicitamente requested máquina automática.

		(d) Off-the-shelf project management tool (Linear, GitHub
		Projects) para tracking de deferimentos. Rejeitada: viola
		regime de governance-as-code (P12). Decisões de deferimento
		são decisões de design (axiomas, schemas, frameworks) — vivem
		no repo onde resto do design vive. External tool fragmenta
		fonte de verdade.

		Pattern de design escolhido após 3 rounds de red-teaming
		(sessão 2026-05-03 chat history): novo artifact type
		first-class #DeferredDecision com:
		- Triggers CODIFICADOS via discriminated union (#Trigger),
		  não prose. Runner determinístico avalia automaticamente
		  cada commit.
		- Lifecycle discriminado por status (open → triggered →
		  resolved/withdrawn) com fields auxiliares enforced por
		  schema.
		- OriginRef union admite path .cue formal OU session:<slug>
		  para origens de chat (decisões informais).
		- Runner emite annotations (PR comments, workflow output);
		  NÃO muta instâncias — separação CUE-declara / script-executa
		  per founder direction.
		- Naming explícito: "deferimento consciente governado" (NÃO
		  "dívida técnica" genérica, que viraria catch-all).
		"""

	decision: """
		Bootstrap de #DeferredDecision artifact type em 2 commits
		coordenados:

		(1) [commit 1, este] Schema + ADR + PG + extensions infrastructure:
		  - architecture/artifact-schemas/deferred-decision.cue:
		    schema #DeferredDecision com discriminated union sobre
		    status (open/triggered/resolved/withdrawn) e #Trigger
		    union (5 kinds: recurrence, adjacent-need, volume-threshold,
		    temporal, manual-review). #OriginRef admite path .cue ou
		    session:<slug>. _qualityCriteria com 4 critérios (tq-def-01..04).
		  - architecture/production-guides/deferred-decision.cue:
		    PG-DeferredDecision com 3 sections (scaffold-and-origin,
		    substance-and-deferral-rationale, trigger-design).
		    _qualityCriteria com 4 critérios (tq-defg-01..04).
		    Cascade ordering compliance per adr-053 + adr-054 dec 13.
		  - architecture/artifact-schemas/quality-criteria.cue:
		    #ArtifactType += "deferred-decision"; abbreviation block
		    += "def (deferred-decision), defg (deferred-decision-guide)".
		  - architecture/artifact-schemas/adr.cue: adicionar field
		    optional defersTo: [...string & =~"^def-[0-9]{3}$"]
		    (ADRs pós-adr-062 SHOULD usar defersTo em vez de prose
		    'Known gaps declarados'; ADRs pré-adr-062 grandfathered).
		  - architecture/structural-checks/production-guide.cue:
		    sc-pg-01.coveredSchemas += "deferred-decision" (cascade
		    ordering enforcement).

		(2) [commit 2, separate] Runner + projection + first instance:
		  - architecture/validation-prompts/validate-deferred-decision.cue:
		    vp-deferred-decision com 4 checks advisory (calibration,
		    origin traceability, rationale articulation, cost coherence).
		  - architecture/structural-checks/deferred-decision.cue:
		    minimal v1 — apenas checks que kinds atuais (per adr-049
		    + adr-056) suportam.
		  - scripts/ci/evaluate-deferred-triggers.sh: runner Python
		    determinístico (pattern paralelo a check-self-review.sh).
		    Itera def-XXX status=open; avalia cada trigger machine-
		    evaluable; emite GitHub Action annotations + workflow
		    output. NÃO muta instâncias.
		  - .github/workflows/deferred-trigger-check.yml: workflow
		    paralelo a self-review-check.
		  - governance/build-time/projections/triggered-deferrals.cue:
		    projection inicial vazia (rebuilt manualmente quando
		    runner emite findings).
		  - architecture/deferred-decisions/def-001-promote-
		    plannedoutputs-to-required.cue: primeira instância real
		    (formaliza pause de C3 Part 4 desta sessão; serve como
		    calibration case do sistema).
		  - governance/claude/config.cue: nova section "Deferimento
		    Consciente Governado" com pointers canônicos.
		  - CLAUDE.md regen.

		Status inicial='accepted' justificado: founder explicitly
		approved pattern + 3 rounds de red-teaming via chat 2026-05-03.

		Defersto field é optional na adição (não required) — ADRs
		pós-adr-062 SHOULD usar quando deferimento codificável existe;
		ADRs pré-adr-062 mantêm prose 'Known gaps declarados'
		grandfathered. Backfill é separate WI futuro (não scope deste
		ADR).

		Manual-review trigger é explicit escape valve com reason
		MinRunes(40): permite deferimentos sem trigger automático
		quando founder articula por que automação não viável (e.g.,
		decisão estratégica que só founder revisita). NÃO é default.
		"""

	consequences: """
		Positivas:

		P1: Deferimentos conscientes têm registro estruturado e
		queryable. Substituí prose 'Known gaps declarados' (não-
		auditável) por instância de tipo first-class.

		P2: Triggers codificados são machine-evaluable. Runner
		determinístico avalia cada commit; deferimentos disparam
		automaticamente quando condição materializa. Elimina
		dependência de revisão periódica do founder (que hoje não
		acontece — projections stale 5+ semanas).

		P3: Discriminated union sobre status enforce transição válida
		via schema. Status open não pode ter triggeredAt; status
		withdrawn requer withdrawalRationale ≥50 runes. Schema-as-
		gate bloqueia inconsistências.

		P4: OriginRef union admite session:<slug> para decisões de
		chat (e.g., def-001 deste commit-2 originou de session
		'resume-mesh-work-jv2mc'). Decisões informais que merecem
		rastreabilidade não ficam fora do regime governado.

		P5: Naming "deferimento consciente governado" (NÃO "dívida
		técnica") evita catch-all semântico. Futuras instâncias têm
		critério claro de pertinência (deferimento decidido com
		trade-off articulado vs trabalho rotineiro que deveria ser WI).

		P6: Pattern reusable para futuras decisões de cobertura
		parcial (WI-068 Opção B é caso imediato; futuras opções B
		similares seguem mesmo padrão).

		P7: Runner não-mutador (annotations, não file edits) evita
		merge conflicts entre runner output e edição humana. Status
		mudança é decisão humana após revisão; runner provê signal
		operacional.

		Negativas:

		N1: Custo de bootstrap real — ~28 arquivos cross-2-commits
		(este: 8 source + 4 SRRs = 12; commit 2: ~9 source + 5 SRRs =
		~14). Para sistema que governa ~5-10 deferimentos/ano
		inicialmente, custo é proporcional ao benefício SOMENTE se
		deferimentos crescem com maturidade (presumido).

		N2: Calibração de triggers é hard problem. Threshold=2 vs 3
		vs 5 é judgment do founder caso-a-caso; calibration ruim
		produz noise (founder ignora) ou silêncio (defeats purpose).
		Mitigação via tq-defg-02 + tq-defg-03 (force articulation).
		Ainda assim risk real.

		N3: Adoption gap — agente/founder pode esquecer de criar
		def-XXX ao deferir. Mitigação: vp-adr eventualmente captura
		"ADR com prose de gaps mas sem defersTo" via check em commit
		futuro (não scope deste ADR). Disciplina manual durante
		interim.

		N4: Schema #ArtifactType cresce 25 → 26. Cada novo valor amplia
		surface de consistência entre quality-criteria.cue,
		validation-prompt.cue, structural-check.cue, e CI mapping
		(per adr-060 framing forward-looking sobre cobertura caso-a-
		caso).

		N5: Bypass conhecido em CUE de hidden-field constraint
		propagation: tq-defg-NN (4 chars) tecnicamente excede regex
		[a-z]{2,3} mas é aceito porque _qualityCriteria é hidden
		field. Convention pre-existente (adr-007 PG-ADR usa tq-adrg-NN
		desde 2026-03-17). Aceitável; documentado.

		Known gaps declarados (não omitidos):
		- Validation-prompt para deferred-decision NÃO neste commit;
		  vai em commit 2 (per plan).
		- Structural-checks para def-XXX são minimais inicialmente
		  (kinds atuais limitam o que pode ser enforçado). Expansão
		  via ADR futuro quando casos concretos justificarem (per
		  pattern adr-049/adr-056).
		- Backfill de prose 'Known gaps declarados' em ADRs pré-adr-062
		  para def-XXX é deferred (separate WI futuro). adr-047,
		  adr-061 mantêm prose; novos ADRs SHOULD usar defersTo.
		- AdjacentCondition v1 minimal (file-exists, file-contains).
		  Expansão (e.g., task-spec-state, schema-has-field) deferida
		  até casos concretos materializarem.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
		"architecture/artifact-schemas/adr.cue",
		"architecture/structural-checks/production-guide.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/deferred-decision.cue",
		"architecture/production-guides/deferred-decision.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P12 (governança como código) é o driver primário: deferimentos
		conscientes em prose 'Known gaps declarados' são governance-as-
		text — não machine-evaluable, drift acumula em silêncio.
		Schema first-class + triggers codificados move concern de
		narrative para código auditável.

		P0 (uma localização canônica): deferimentos vivem em UM tipo
		(architecture/deferred-decisions/) com schema único. Substitui
		dispersão atual: prose em ADRs, decisões em chat history,
		WIs em task-approved sem trigger.

		P1 (CUE como SoT): schema #DeferredDecision com discriminated
		unions enforce shape via cue vet — schema é fonte de verdade
		para forma; runner consome forma para automação.

		P10 (gates determinísticos): runner é determinístico (filesystem
		state + date math); não usa LLM como gate. Annotations advisory;
		mudança de status é humana. Alinhado com adr-040 split.

		Failure mode evitado: deferimento como dívida não-auditável
		que acumula sem cobrança. Padrão observado em projeções stale
		5+ semanas + 29 WIs em task-approved. Sistema atual depende
		de memória do founder; máquina automática elimina dependência.

		Tensão com axiomas: nenhuma tensão substantiva. ax-04 (decidir
		hoje o que gostaríamos de ter decidido em 5-10 anos) é
		reforçado — máquina automática é decisão tomada hoje que
		evita débito futuro.

		Lenses consultadas:

		lens-real-options: deferimento é opção real (postergar decisão
		para data futura quando informação for melhor). Triggers são
		strike conditions da opção; resolução é exercise. Lens reforça
		valor de articular trade-off (custo de exercer agora vs custo
		de continuar com opção aberta).

		Relação com outras ADRs:

		- DESCENDS adr-040 (validação split estrutural vs advisory) —
		  runner é structural check (advisory annotations, não gate);
		  validation-prompt vp-deferred-decision (commit 2) é advisory
		  semantic.
		- DESCENDS adr-053 (cobertura universal de PGs) + adr-054
		  dec 13 (cascade ordering) — PG-DeferredDecision criado
		  ANTES de qualquer instância def-XXX; sc-pg-01.coveredSchemas
		  estendido para enforce.
		- COMPLEMENTS adr-038 (#TensionEntry schema) — tension-entry
		  e deferred-decision são tipos disjuntos. tension-entry para
		  forças de design em conflito; deferred-decision para
		  trabalho-deferido com trigger.
		- ENABLES futuras decisões de cobertura parcial: WI-068 Opção B
		  é caso imediato; pattern reusable para opções B similares
		  futuras.
		- SEM supersession.

		Justificativa de risk metadata:

		decisionClass='structural': cria novo artifact type cross-cutting,
		altera schema #ADR, adiciona nova abreviação, estende
		#ArtifactType. Não é foundational (não muda governança ou
		SoTs base); não é local (toca múltiplos schemas).

		reversibility='medium': revertir exige (a) remover schema +
		PG + extensions, (b) remover instâncias def-XXX existentes,
		(c) restaurar prose 'Known gaps declarados' em ADRs pós-
		adr-062. Possível mas custo cresce com instâncias. medium
		(não high) porque defersTo field em ADRs cria backward
		compat consideration.

		blastRadius='cross-cutting': afeta governance (novo tipo +
		PG + abbreviation), architecture (schema + structural-check
		extension), CLAUDE.md em commit 2, e workflow CI em commit 2.
		Não é repo-wide (não toca BCs nem domain).
		"""
}
