package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr106: artifact_schemas.#ADR & {
	id:    "adr-106"
	title: "Reduzir o bucket de isenções cross-file do M2: checks reais (domain-definition, service-contract) + recategorização honesta"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-101 isentou 8 tipos no bucket "(def-002)" do sc-meta-02 (cobertura M2),
		sob a premissa de que tinham refs cross-file aguardando o kind
		cross-file-id-exists. Com os kinds cross-file agora construídos (adr-102/105),
		era hora de converter placeholders de isenção em cobertura real.

		A investigação dos 8 reenquadrou o bucket — vários NÃO têm ref cross-file (a
		categoria def-002 estava incorreta):
		- subdomain: campos code/definition/name/type, auto-contidos — sem ref.
		- stakeholder-map: stakeholders[] auto-contidos — sem ref.
		- policy: 0 instâncias — nada a checar.
		E dois têm ref cross-file DIRETA e born-green:
		- domain-definition: designPrinciplesRef + stakeholderMapRef são PATHS.
		- service-contract: boundedContextRef é id de context.
		Os outros três (agent-spec, economic-mechanism-model, cross-context-flow) têm
		ref cross-file genuína mas com risco de vocabulário/materialização (como o
		events↔BC do def-019) — deferidos com rationale específico.

		Alternativa REJEITADA: autorar checks para os 8 de uma vez. Reprovada — 3 não
		têm ref (check seria vazio/forçado) e 3 têm risco de vocabulário; forçar
		geraria ruído. Cobertura real > cobertura nominal.
		"""

	decision: """
		(1) Autorar checks reais (born-warn, born-green), sem kind novo:
		    - domain-definition: sc-dd-01 (designPrinciplesRef) + sc-dd-02
		      (stakeholderMapRef) via filesystem-path-exists (refs são paths).
		    - service-contract: sc-sv-01 (boundedContextRef ∈ context-map
		      contexts[].context) via cross-file-id-exists.
		    Removidos do exemptTypes do sc-meta-02 (agora cobertos).

		(2) Recategorizar isenções mal-bucketadas (não forçar def-002 onde não há ref):
		    - subdomain → (P): sem ref cross-file.
		    - stakeholder-map → (P): sem ref cross-file.
		    - policy → (sem instâncias): nenhuma instância pol-*.cue ainda.

		(3) Deferir os 3 genuinamente cross-file com rationale ESPECÍFICO (não
		    genérico): agent-spec (risco vocabulário commands/capabilities, como
		    def-019); economic-mechanism-model (semântica de enforces/protectsAgainst
		    a investigar); cross-context-flow (ownerContext/ownerSubdomain checáveis +
		    integrationEvents com risco vocabulário — autorar parcial em sub-pass).

		Efeito: bucket cross-file do M2 de 8 → 3; +3 checks reais; M2 permanece em
		zero descobertos (os cobertos saem; os recategorizados continuam isentos com
		rationale honesta).

		FORA DE ESCOPO: promoção dos novos checks a reject (born-warn por ora — o
		objetivo é cobertura real, não promoção); os 3 deferidos (sub-pass futuro).
		"""

	consequences: """
		Positivas: (1) +3 checks determinísticos reais substituem placeholders de
		isenção; (2) o bucket cross-file encolhe de 8 para 3 com rationale honesta
		(metade era mal-categorizada); (3) reusa kinds existentes (filesystem-path-
		exists, cross-file-id-exists) — sem inflar ontologia; (4) os deferidos têm
		rationale específico (vocabulário, semântica, instâncias), não "exige
		cross-file-id-exists" genérico.

		Negativas: (1) os 3 deferidos seguem sem gate (mas agora com diagnóstico
		preciso do porquê); (2) sc-sv-01 cobre só boundedContextRef do service-contract
		(async/sync/errors podem ter refs a events — fora deste pass, mesmo risco
		vocabulário); (3) born-warn — não bloqueia ainda (promoção é decisão à parte).
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/structural-checks/domain-definition.cue",
		"architecture/structural-checks/service-contract.cue",
		"architecture/structural-checks/meta-coverage.cue",
	]

	principlesApplied: [
		"P10 — gate determinístico: refs cross-file por path/id viram travas reais",
		"P0 — localização canônica: reusa kinds existentes; isenções com rationale específico, não placeholder",
		"adr-099/101 — reduz o bucket de isenções do M2 com cobertura real (não nominal)",
		"adr-062 — anti-catch-all: recategorização honesta em vez de forçar def-002 onde não há ref",
		"dp-07 — sem big-bang: born-warn; 3 born-green agora, 3 deferidos com diagnóstico específico",
	]

	defersTo: []

	rationale: """
		decisionClass structural: adiciona 3 structural-checks reais, recategoriza
		isenções e encolhe o bucket cross-file do M2 — aplica P0/P10/adr-099 sem
		redefinir princípios. reversibility medium (aditivo, born-warn); blastRadius
		repo-wide (cobertura do M2).

		Verificado antes da proposta: investigação dos 8 (instâncias + campos
		referenciais) reenquadrou o bucket; cue vet ./... EXIT 0; runner --self-test
		PASS; runner default → sc-dd-01/02 e sc-sv-01 verdes (paths/id existem), M2
		descobertos = 0, 0 bloqueantes, exit 0.
		"""
}
