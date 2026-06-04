package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def040: build_time.#SelfReviewReport & {
	reportId: "srr-def-040-http-runtime-stack"

	artifactPath:       "architecture/deferred-decisions/def-040-http-runtime-stack.cue"
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
			Self-review do def-040 (stack de runtime HTTP — framework/IdP/ingress — deferida de adr-140).
			Avaliado contra universalCriteria + tq-def-01..04.
			tq-def-01 (trade-off concreto): custo evitado (especular stack HTTP — servidor+auth+ingress —
			antes de existir runtime que os exercite, lock-in prematuro que real-options/adr-138 evita) vs
			custo de continuar (spec sem runtime HTTP, mitigado porque o golden-example não expõe HTTP per
			def-039 e o contrato adr-140 basta como âncora). Não é "fazer depois". Pass.
			tq-def-02: adjacent-need file-exists conforme #Trigger, machine-evaluable. Pass.
			tq-def-03 (≥1 non-manual): trigger non-manual (adjacent-need). Pass.
			tq-def-04 (coerência): low + cross-cutting — coerente (runtime puro fora do caminho crítico =
			low; ponto de entrada de TODOS os BCs sobre HTTP quando materializar = cross-cutting; não é o
			par suspeito low+repo-wide; mesmo par de def-037). Pass.
			uq-02 (Mesh): framework HTTP/IdP/ingress atrás de Port (P2), golden-example sem HTTP,
			def-037/adr-138/adr-139 — específico. uq-08 (conforma #DeferredDecision): status=open
			(auxiliary fields ausentes); MinRunes em description/deferralRationale/triggerCalibrationRationale;
			cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		def-040 defere a seleção de framework HTTP, IdP e ingress (runtime que serve o slice de contrato
		HTTP de adr-140) — tooling de runtime atrás dos Ports (P2), não contrato de domínio. Trigger
		adjacent-need file-exists em adr-141 (mesmo checkpoint de def-037, machine-evaluable). low/
		cross-cutting. Estável em 1 round, 0 findings.
		"""

	singleRoundRationale: """
		Deferral com calibração travada pelo founder (low/cross-cutting; trigger adjacent-need adr-141
		espelhando def-037, machine-evaluable); conformance a #DeferredDecision verificável por inspeção
		(MinRunes, shape do trigger, união discriminada status=open, cue vet EXIT=0). Trade-off concreto
		articulado — sem ambiguidade que rounds adicionais resolveriam.
		"""
}
