package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

cmtCanvas: build_time.#SelfReviewReport & {
	reportId: "srr-canvas-cmt"

	artifactPath:       "contexts/cmt/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/canvas.cue"
	artifactType:       "canvas"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-01T00:00:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Canvas estabilizou em 1 round de self-review porque passou por
		3 rounds de red-team pré-proposta (verificação completa dos 12
		quality criteria do schema + 8 universais) seguidos de 4 ajustes
		do founder (domainAgentSpec canônico por path, SoT explícito,
		CommitmentProposed declarado interno, solução técnica removida
		de businessDecisions). Todas as correções foram aplicadas antes
		do commit. Self-review confirmou zero findings.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliou CMT canvas contra 8 critérios universais (uq-01..08) e
			12 type-specific (tq-cv-01..12). Zero findings. Destaques:
			uq-02 (Mesh-specific) passa porque canvas referencia
			mech-evidence, mech-agent-gate, CommitmentId, dp-08, dp-10.
			uq-03 (cross-refs) passa com sh-01..05, ce-02, cc-04 e 4
			context refs (rew, drc, ctr, bdg) validados contra
			stakeholder-map, domain-definition e context-map. tq-cv-03
			(incentive analysis) passa com manipulationCost concreto para
			proponente (inflação detectada por DLV/REW) e contraparte
			(sub-dimensionamento detectado na verificação). tq-cv-06
			(communication coherence) passa com sync entries
			(ConfirmCommitmentAcceptance, QueryCommitmentState,
			QueryContractTerms) e async entries (ProposeCommitment,
			3 event-consumers, 2 event-publishers). tq-cv-10 (core BC
			com costsEliminated) passa com ce-02 preenchido.
			"""
	}]

	findings: {}

	summary: """
		CMT canvas é o primeiro BC canvas instanciando o schema evoluído
		(ADR-034). Cobre identidade, classificação (core/revenue-generator/
		custom), domain roles (execution + draft), 3 capabilities operacionais,
		comunicação alinhada com context map (5 relationships), 3 business
		decisions (aceite bilateral, CommitmentId origin, validação de termos),
		5 stakeholders, custo eliminado (ce-02), incentive analysis com 2
		participantes, ownership com domainAgentSpec canônico por path,
		governance scope (3 autônomas, 2 supervisionadas, 3 escalação),
		3 assumptions, 2 open questions e 3 verification metrics. Estável
		em 1 round após 3 rounds de red-team e 4 ajustes do founder.
		"""
}
