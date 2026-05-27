package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr114: artifact_schemas.#ADR & {
	id:    "adr-114"
	title: "Catraca: promover a reject os 5 structural-checks cross-file born-green (sc-em-01/02, sc-ccf-01/02, sc-ag-01)"
	date:  "2026-05-27"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Os passes adr-111/112/113 autoraram structural-checks cross-file born-warn que
		provaram verde desde a autoria (born-green verificado por protótipo + cue vet +
		runner em cada pass): mecanismo econômico→assumptions (sc-em-01/02),
		cross-context-flow→context-map/subdomains (sc-ccf-01/02) e agent-spec→
		domain-model do próprio BC (sc-ag-01). São a geração de checks que zerou o
		bucket cross-file do M2 (adr-113).

		Per a catraca do adr-097/adr-109 (born-warn → reject quando comprovadamente
		verde e de valor), é hora de converter essa cobertura nominal em gate real
		(P10): um check que só reporta em warn torna o drift visível mas não o impede.
		Os 5 estão verdes e guardam drift referencial concreto (mecanismo apontando
		para imperativo/risco fantasma; phase atribuída a BC/subdomínio inexistente;
		agent referenciando building block fora do seu domain-model = responsabilidade
		fantasma / vazamento cross-BC).

		Alternativa REJEITADA: manter em warn. Reprovada — o valor de gate só se
		realiza com reject; os 5 estão verdes e a dimensão que NÃO resolve
		(integrationEvents do cross-context-flow) já está fora destes checks (deferida
		em def-021), então a promoção não arrasta ruído de roadmap.
		"""

	decision: """
		Promover enforcement "warn" → "reject" nos 5 checks cross-file born-green:
		- economic-mechanism-model.cue: sc-em-01 (enforces → imp-*), sc-em-02
		  (protectsAgainst → ri-*).
		- cross-context-flow.cue: sc-ccf-01 (phase.ownerContext → context-map
		  contexts[].context), sc-ccf-02 (phase.ownerSubdomain → subdomains/*.cue code).
		  Cobrem só as âncoras estruturais; integrationEvents segue fora (def-021).
		- agent-spec.cue: sc-ag-01 (operationalScope/domainModelRefs → domain-model do
		  próprio BC, instance-scoped-cross-file-id-exists).

		Verificado zero findings nos 5 antes da promoção → nascem verdes como gate;
		runner default segue exit 0 (0 bloqueantes). Um drift novo em qualquer dessas
		dimensões passa a FALHAR o CI.

		FORA DE ESCOPO: sc-cv-02/03 (têm findings — decisão de produto api/async,
		permanecem warn); os 71 domain-invariant checks (avaliar promoção
		separadamente, caso a caso).
		"""

	consequences: """
		Positivas: (1) 5 dimensões de integridade cross-file (modelo econômico,
		cross-context-flow, agent-spec) passam a IMPEDIR drift por construção, não só
		reportar; (2) a catraca avança — cobertura comprovada vira gate; (3) nenhum
		custo de falso-positivo (todos verdes, verificado); (4) consolida o trabalho
		que zerou o bucket cross-file do M2 (adr-113) em enforcement efetivo.

		Negativas: (1) um PR futuro que introduza drift numa dessas dimensões agora
		FALHA o CI (intenção, não defeito); (2) se um desses checks tiver um caso de
		borda não previsto, o falso-positivo passa a bloquear — mitigado por born-green
		consistente e pela reversibilidade alta (reverter a warn é uma linha).
		"""

	reversibility: "high"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/structural-checks/economic-mechanism-model.cue",
		"architecture/structural-checks/cross-context-flow.cue",
		"architecture/structural-checks/agent-spec.cue",
	]

	principlesApplied: [
		"P10 — gate determinístico: cobertura cross-file comprovada vira trava real (reject), não relatório (warn)",
		"adr-097 — per-check enforcement + catraca born-warn→reject; adr-109 — precedente direto desta promoção",
		"adr-113 — consolida o fechamento do bucket cross-file do M2 em enforcement efetivo",
		"adr-062 — a dimensão que não resolve (integrationEvents) já está deferida (def-021), então a promoção não arrasta roadmap",
		"dp-07 — sem big-bang: promove só o comprovadamente verde; sc-cv-02/03 e domain-invariants ficam fora",
	]

	defersTo: []

	rationale: """
		decisionClass structural: altera o enforcement (warn→reject) de 5 checks —
		aplica a catraca do adr-097/adr-109 sem redefinir princípios nem schemas.
		reversibility high (uma linha por check); blastRadius repo-wide (CI gate).

		Verificado antes da proposta: cue vet ./... EXIT 0; runner --self-test PASS;
		runner default → os 5 promovidos sem FAIL/WARN (born-green como gate), 0
		bloqueantes, exit 0 (só os 21 warns pré-existentes de sc-cv-02/03 seguem, e
		esses permanecem warn por decisão).
		"""
}
