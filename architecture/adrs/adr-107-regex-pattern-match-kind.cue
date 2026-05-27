package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr107: artifact_schemas.#ADR & {
	id:    "adr-107"
	title: "Kind regex-pattern-match (resolve def-003) + check de convenção de event-name (sc-ev-01)"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-104 canonizou a identidade de event (name PascalCase = chave
		cross-artifact) e reconciliou os 4 names tocados. Mas a convenção não estava
		travada: 22 de 83 event names ainda violam PascalCase (rew com parentéticos,
		dlv/inv com espaços). Sem gate de convenção, o vocabulário pode driftar de
		novo (alguém volta a escrever "Risk Alert Raised").

		def-003 (aberto desde 2026-05-03) registrava a falta do kind
		regex-pattern-match: validar que um valor de campo conforma a uma regex —
		convenção de formato que cue vet (constraint de schema) não impõe sobre um
		campo de string livre. O kind é genérico; a convenção de event-name é a
		primeira aplicação (def-003 também nomeia sc-srr-02/sc-ts-02 como alvos
		futuros).

		O check de event-name NÃO nasce verde: 22 names violam a convenção hoje
		(só 4 foram normalizados no adr-104). Decisão do founder (opção a): autorar o
		kind + o check BORN-WARN — declara a convenção, surface os 22 como inventário,
		impede novo drift silencioso. A normalização dos 22 (→ promover a reject) é
		sub-pass futuro com decisões de nome.

		Alternativa REJEITADA: normalizar os 22 no mesmo pass (born-green direto).
		Reprovada por ora — os parentéticos do rew ("...(published cross-BC)") carregam
		detalhe que precisa migrar para description; merece revisão de nome, não é
		puramente mecânico. Born-warn primeiro, normalização depois (catraca).
		"""

	decision: """
		(1) Kind novo regex-pattern-match (#RegexPatternMatchRule {valuePath,
		pattern}): todo valor em valuePath (travessia "[]"/aninhamento) deve casar a
		regex pattern. Kind genérico para convenção de formato sobre campo livre.

		(2) Check sc-ev-01 (architecture/structural-checks/domain-model-event-convention.cue),
		born-warn: domain-model.events[].name casa ^[A-Z][A-Za-z0-9]*$ (PascalCase,
		sem espaços/parentéticos). Hoje dispara em 22 names (inventário de
		normalização); 0 bloqueantes.

		(3) def-003 → resolved (resolvedBy adr-107). A CAPACIDADE existe; outros checks
		nomeados (sc-srr-02 artifactSchemaPath casa regex do tipo; sc-ts-02) são
		instanciação futura (sc-srr-02 pode exigir extensão p/ pattern derivado de
		outro schema — fora deste pass).

		FORA DE ESCOPO: normalizar os 22 event names (sub-pass — decisões de nome
		canônico + migrar detalhe dos parentéticos para description) → então promover
		sc-ev-01 a reject; sc-srr-02/sc-ts-02.
		"""

	consequences: """
		Positivas: (1) a convenção de event-name passa a ser enforçada (warn) —
		impede aceitar silenciosamente um name não-canônico; (2) surface os 22 names
		não-normalizados como backlog explícito; (3) o kind é reutilizável para
		qualquer convenção de formato (sc-srr-02/sc-ts-02 e outros); (4) completa o
		loop do adr-104 (canonizou; agora trava).

		Negativas: (1) born-warn — não bloqueia ainda; o drift novo só é IMPEDIDO após
		normalizar os 22 e promover a reject; até lá é visibilidade; (2) o kind faz
		match literal (re.match) — o caso "pattern derivado do canonicalPathRegex de
		outro schema" (sc-srr-02) precisaria de extensão; declarado fora de escopo;
		(3) mais um kind no #StructuralCheck — capacidade genuinamente nova (validação
		de convenção de formato), não redundante.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/structural-checks/domain-model-event-convention.cue",
		"architecture/deferred-decisions/def-003-add-regex-pattern-match-kind.cue",
	]

	principlesApplied: [
		"P10 — gate determinístico: conformância a uma regex é decidível e vira trava",
		"P0 — localização canônica: convenção declarada no check, não em prosa; kind genérico no schema",
		"adr-104 — trava o vocabulário canônico de event que adr-104 estabeleceu",
		"adr-097 — born-warn + catraca: nasce warn (22 findings), promove a reject após normalização",
		"dp-07 — sem big-bang: kind + guard-warn agora; normalização dos 22 em sub-pass",
	]

	defersTo: []

	rationale: """
		decisionClass structural: novo kind + rule shape no #StructuralCheck, novo
		evaluator no runner, 1 instância, resolução de def-003 — aplica P0/P10/adr-104
		sem redefinir princípios. reversibility medium (aditivo, born-warn); blastRadius
		repo-wide (kind disponível ao repo).

		Verificado antes da proposta: cue vet ./... EXIT 0; runner --self-test PASS;
		runner default → sc-ev-01 dispara 22 findings em warn (inventário), 0
		bloqueantes, exit 0. def-003 resolvido (capacidade); normalização dos 22 e
		demais checks nomeados ficam para sub-pass.
		"""
}
