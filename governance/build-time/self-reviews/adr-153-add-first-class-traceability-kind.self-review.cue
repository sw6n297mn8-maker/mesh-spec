package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr153: build_time.#SelfReviewReport & {
	reportId: "srr-adr-153-add-first-class-traceability-kind"

	artifactPath:       "architecture/adrs/adr-153-add-first-class-traceability-kind.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-16"

	roundsExecuted: 3
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 -- review por SUB-AGENTE ISOLADO (rollout adr -> isolated-subagent), sem o
			historico da sessao de autoria, sobre adr-153 completo. Sete pontos de ataque +
			uq-01..09 + tq-adr-01/02/03, verificacao contra o disco (incl. os pilotos via git show
			sim/firstclass-fce|shared). 6/7 pontos PASS: (2) bundle-nao-split FORCADO --
			ev_evaluator_coverage (structural-check-runner.py) + sc-meta-01 enforcement:reject
			quebram o build se um kind entra no enum sem evaluator em EVAL; o ADR so alega
			atomicidade kind+evaluator, sem overclaim. (3) kind unico vs narrow -- os pilotos
			constroem 1 concept_index + 1 norm() de onde G1-G5 e B1-B4 leem; narrow recomputaria,
			justificativa fiel. (4) falsificationCondition cobre os dois lados (falso-positivo +
			falso-negativo), ambos observaveis. (5) principlesApplied load-bearing -- P0/P10/P12
			existem (design-principles.cue 21/166/200) e sao usados; adr-151/adr-099 idem; adr-040
			citado em consequences (2) existe e e o precedente certo (split deterministico/advisory).
			(6) split adr-059 conforma -- os 2 affectedArtifacts existem e os 2 plannedOutputs nao
			(git ls-files). 1 FINDING WARN no ponto (1) escopo G2: a decisao (5) declarava "cruza
			contrato" = port-manifest + aggregate-manifests (2 triggers), mas adr-151:111 define 3
			(port-manifest, ASSERTION, aggregate-manifest) -- "Fiel ao adr-151" era overclaim
			droppando assertion silenciosamente. Inerte no disco hoje (zero instancias
			*.assertion.cue; def-049 open) mas a alegacao de fidelidade era imprecisa. Severidade
			warn (toca uq-04/coerencia mas inerte). cue vet EXIT=0.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 -- conserto do unico finding (warn, ponto 1) e re-verificacao. A decisao (5)
			foi reescrita: declara explicitamente que adr-151 (§1) define "cruza contrato" por 3
			artefatos (port-manifest, assertion, aggregate-manifest), cobre os 2 com
			formato/instancias materializados hoje (port-manifest + aggregate-manifests; 4 BCs
			cmt/dlv/fce/rew), e DEFERE o trigger assertion ancorado em def-049 (nao se checa
			membership num artefato cujo formato/localizacao e indefinido enquanto def-049 estiver
			open; def-049-assertion-to-test-mechanism existe, status open). O observableSignal foi
			trocado por "membership nas fontes de cruza-contrato per decisao (5)" (P0 -- a decisao
			5 vira fonte unica do escopo, evita drift quando assertion entrar). Isso torna "Fiel ao
			adr-151" PRECISO -- cobre o checavel, defere o nao-checavel com condicao de revisita
			ancorada -- em vez de droppar assertion silenciosamente. cue vet EXIT=0; fmt-canonical.
			Nenhum novo finding introduzido; os 6 pontos restantes + uq/tq permanecem PASS. Round 2
			limpo (0 fail, 0 warn).
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Round 3 -- refinamento de materializacao (decisao de design Q1, NAO um pass de
			review isolado): ao fixar o escopo da V1 do evaluator (so aggregate-manifest,
			mapeamento deterministico), emergiu uma SEGUNDA divergencia ADR-vs-implementacao
			da MESMA CLASSE que o finding do round 1. A decisao (5) ainda alegava cobrir
			port-manifest + aggregate-manifest, mas a V1 cobre SO aggregate-manifest -- o
			port-manifest lista value-class canonicas (StreamId, AppendResult), nao vo-
			codes; mapea-las por aproximacao violaria P10/norm()-exato (a categoria de erro
			que a falsificationCondition condena). Patch: decisao (5) agora declara os 3
			triggers do adr-151, cobre so aggregate-manifest na V1, e DEFERE assertion
			(def-049, prose-ref) E port-manifest (def-063, criado neste bundle), ambos com
			razao + condicao de revisita; defersTo:["def-063"] adicionado ao ADR. O
			self-review valeu 2x: a disciplina que pegou o assertion (round 1) pegou o
			port-manifest ANTES de materializar com overclaim. cue vet EXIT=0. Warn resolvido
			no mesmo patch; zero residual.
			"""
	}]

	findings: {}

	summary: """
		adr-153 (accepted, BUNDLE kind-ADR) adiciona o kind structural-check
		first-class-traceability -- 1 kind/evaluator que emite os 9 findings (G1-G5 Forma A +
		B1-B4 Forma B), materializando o enforcement (passos v-vi do D2) do adr-151. Self-review
		em 3 rounds: round 1 (SUB-AGENTE ISOLADO, rollout adr->isolated-subagent; 7 pontos de
		ataque + uq/tq contra o disco) achou 6/7 PASS + 1 WARN no escopo G2 -- a decisao (5)
		droppava 1 dos 3 triggers de "cruza contrato" (assertion) que adr-151:111 define; round 2
		consertou (defere assertion via def-049). Round 3 (refinamento de materializacao Q1, NAO
		pass isolado) pegou uma SEGUNDA divergencia da mesma classe -- a decisao (5) ainda alegava
		cobrir port-manifest, mas a V1 cobre so aggregate-manifest; patch defere tambem
		port-manifest via def-063 (criado no bundle, defersTo:["def-063"]). O self-review valeu
		2x: a disciplina que pegou o assertion pegou o port-manifest ANTES de materializar com
		overclaim. cue vet EXIT=0. Zero fail residual; estavel em 3 rounds. A materializacao do
		bundle (enum + evaluator + instancia warn + worklist) segue sob este ADR no mesmo PR
		atomico.
		"""
}
