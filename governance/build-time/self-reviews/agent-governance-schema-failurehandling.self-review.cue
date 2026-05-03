package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

agentGovernanceSchemaFailurehandling: build_time.#SelfReviewReport & {
	reportId: "srr-agent-governance-schema-failurehandling"

	artifactPath:       "architecture/artifact-schemas/agent-governance.cue"
	artifactSchemaPath: "architecture/artifact-schemas/quality-criteria.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-01"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Schema #AgentGovernanceEnvelope estendido per adr-058: (1) novo sub-tipo #FailureHandling adicionado após #RegressionAction (linhas 462-487; 4 fields sub-shape: onAgentError, onTimeout, onRepeatedFailure, rationale); (2) novo campo failureHandling: #FailureHandling adicionado a #AgentGovernanceEnvelope (linha 167) como REQUIRED (não opcional) entre calibration e rationale. Reutiliza #RegressionAction enum existente sem expansion — semantic distinction via description e retryPolicy fields per founder direction. Extension exige migração das 4 instances existentes (cmt/ctr/npm/idc envelopes) — coordenado no MESMO commit. Pattern adr-041 v1 minimal preservado (kind narrow por caso); discipline tq-gvg-08 promovida de tech debt narrative para schema first-class enforced. tq-as-XX critérios do schema artifact-schema satisfeitos por inspeção: shape sub-tipo consistente com pattern dos outros sub-tipos (#DriftDetectionConfig, #CalibrationRules); comments substantivos. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: """
		architecture/artifact-schemas/agent-governance.cue estendido per
		adr-058 (commit subsequente nesta sessão) com novo sub-tipo
		#FailureHandling + campo failureHandling required em
		#AgentGovernanceEnvelope. Promove tq-gvg-08 de tech debt
		narrative para schema first-class enforced. Single round porque
		mudança é estrutural-aditiva coesa autorada como parte do commit
		unificado de adr-058 — review distribuído ocorreu via approval
		do próprio adr-058 que especifica items 1-3 dessa extension.
		"""

	singleRoundRationale: """
		Esta extension é parte estrutural inseparável da decisão registrada
		em adr-058 (promote failureHandling first-class). Review do schema
		delta ocorreu via review do próprio adr-058 — founder aprovou
		decision items 1-3 (sub-tipo + field required + reuse de
		#RegressionAction sem expansion) + risk metadata (medium/
		cross-cutting). Round 1 do self-review verifica: (a) cue vet
		./... passa EXIT=0 com 4 instances migradas (todas validam contra
		o novo required field), (b) sub-tipo segue pattern dos outros
		sub-tipos do schema (#DriftDetectionConfig, #CalibrationRules),
		(c) reuse de #RegressionAction sem expansion preserva backward
		compatibility do enum, (d) field required (não opcional) garante
		enforcement por construção em todas instances futuras. Multiple
		rounds retroativos seriam fabricação — única round real é
		verificação post-write da decisão já aprovada.
		"""
}
