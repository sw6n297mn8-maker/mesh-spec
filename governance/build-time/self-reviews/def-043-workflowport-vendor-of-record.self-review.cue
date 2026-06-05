package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def043: build_time.#SelfReviewReport & {
	reportId: "srr-def-043-workflowport-vendor-of-record"

	artifactPath:       "architecture/deferred-decisions/def-043-workflowport-vendor-of-record.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-04"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-043 (vendor-of-record do WorkflowPort — SoT da execução, categoria
			workflow / durable-execution engine — deferido). Avaliado contra tq-def-01..04 +
			universalCriteria.
			tq-def-01 (trade-off concreto): deferralRationale articula custo evitado (especular um durable
			execution engine antes de o harness WI-137 exercitar o Port = lock-in prematuro per
			P2/real-options) vs custo de continuar (spec sem vendor, mitigado porque o reference adapter
			in-memory destrava o golden-example). Não é "fazer depois". Pass.
			tq-def-02 (trigger codificado): adjacent-need file-exists em scripts/ci/validate-codegen.sh
			conforme #Trigger, machine-evaluable. Pass.
			tq-def-03 (≥1 non-manual): sim — adjacent-need é non-manual. Pass.
			tq-def-04 (custo coerente): low + cross-cutting — reference adapter destrava o golden-example
			(low, fora do caminho crítico) e o WorkflowPort é consumido por todos os BCs (cross-cutting);
			não é o par suspeito low+repo-wide; mesmo par de def-040. Pass.
			uq (Mesh): WorkflowPort, três SoTs, reference adapter, harness WI-137 — específico e agnóstico
			de vendor (zero produto nomeado). uq-08: status=open (auxiliares ausentes), MinRunes em
			description/deferralRationale/triggerCalibrationRationale, cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		def-043 defere a seleção do vendor de durable execution que implementa o WorkflowPort (SoT da
		execução) — categoria de runtime atrás do Port (P2), não contrato de domínio. Agnóstico (nenhum
		produto nomeado), forma def-040/049, deferimento JIT ancorado no harness de codegen-validation
		(WI-137). Estável em 1 round, 0 findings.
		"""

	singleRoundRationale: """
		Self-reported: deferred-decision estrutural simples espelhando o precedente def-040/def-049 do
		mesmo arco (adr-141); deferred-decisions não têm workOrder multi-gate como ADRs. Conformance a
		#DeferredDecision verificável por inspeção (MinRunes, shape do trigger adjacent-need, união
		discriminada status=open, cue vet EXIT=0); trade-off concreto articulado — sem ambiguidade que
		rounds adicionais resolveriam.
		"""
}
