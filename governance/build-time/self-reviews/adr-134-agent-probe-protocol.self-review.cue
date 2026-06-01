package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr134: build_time.#SelfReviewReport & {
	reportId: "srr-adr-134-agent-probe-protocol"

	artifactPath:       "architecture/adrs/adr-134-agent-probe-protocol.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-31"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-134 (process ADR do Ciclo 4 — agent-probe protocol).
			NOTA de execução: o rollout de quality-gate.cue prescreve isolated-subagent
			para adr; aqui foi self-reported (manual takeover — o fluxo de materialização
			do Ciclo 4 não dispôs de subagente isolado). Avaliado contra 8 universalCriteria
			+ tq-adr (alternativas avaliadas, metadata de risco, paths existem).

			uq-01 (WHY): rationale explica por quê — probe-por-reconstrução com isolamento
			falsifica a spec (vs validation-prompt que ratifica). Pass.
			uq-02 (Mesh): é o Ciclo 4 de feedback de build-time da Mesh (P10/adr-040). Pass.
			uq-03 (refs): affectedArtifacts apontam a paths que existem (os 2 schemas, sc,
			instâncias); def-035 criado no mesmo PR. Pass.
			uq-04 (princípios): P10 (probe advisory, não gate), P0 (lar canônico), P12
			(gate de cobertura como fitness function versionada). Pass.
			uq-05 (limitações): consequências declaram N1 (zombie warn), N2 (Goodhart
			residual via stub — mitigado por DoD), N3 (cross-BC do FailureClass). Pass.
			uq-06 (ubiquitous language): probe, finding, disposition, cobertura — estáveis. Pass.
			uq-07 (zero placeholder): nenhum. Pass.
			uq-08 (conforma #ADR): decisionClass/decider/status/falsificationCondition{condition,
			observableSignal}/affectedArtifacts/principlesApplied/supersedes presentes;
			cue vet EXIT=0. Pass.
			tq-adr (alternativas): context avalia (a) sem gate de cobertura [C: nada-garante,
			rejeitado], (b) cobertura como métrica dd-status [rejeitado — menos visível],
			(c) gate born-reject [rejeitado — born-red]; escolheu A born-warn. Pass.
			"""
	}]

	findings: {}

	summary: """
		adr-134 institui o Ciclo 4 (agent-probe protocol): 2 schemas (#AgentProbeProtocol
		self-contained + #AgentProbeRecord com DoD-completeness via união discriminada),
		#ArtifactType +2, sc-apr-01 (referencial) + sc-apr-02 (cobertura A born-warn),
		exemptTypes do protocol, e o 1º probe-record (fce). falsificationCondition
		(dogfood #5) observa conluio/zombie/DoD-insuficiente. Residual em def-035.
		Estável em 1 round, zero findings.
		"""

	singleRoundRationale: """
		Decisão moldada em diálogo extenso com o founder (cobertura A confirmada,
		taxonomia de finding fixada, falsificationCondition redigida pelo founder).
		O ADR materializa decisões já tomadas; critérios verificáveis por inspeção
		direta (conformance a #ADR estrutural; alternativas rastreáveis no context).
		Self-reported por ausência de subagente isolado no fluxo; sem ambiguidade pendente.
		"""
}
