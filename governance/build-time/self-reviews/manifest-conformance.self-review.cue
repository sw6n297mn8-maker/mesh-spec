package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

manifestConformance: build_time.#SelfReviewReport & {
	reportId: "srr-manifest-conformance"

	artifactPath:       "architecture/structural-checks/manifest-conformance.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-05"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review em sessao: 3 checks sc-pmc-01/02/03 (operations[].port, contractTestsRequired[].port,
			adaptersForGoldenExample[].port subset de portsConsumed), kind local-field-reference-integrity,
			artifactType port-manifest, born-warn (enforcement default). Conforma #StructuralCheck (uniao
			discriminada kind<->rule {referencePath, namespacePath}); o kind ja tem evaluator (sc-meta-01).
			Dormant-safe: 0 instancias de PortManifest -> 0 violacoes. Materializa o item 5(a) do adr-144
			(framing 3x local-field-reference-integrity confirmado no re-review isolado conjunto). cue vet
			pass. Sem fail.
			"""
	}]

	findings: {}

	summary: """
		manifest-conformance.cue (3x local-field-reference-integrity; well-formedness do PortManifest).
		Self-review LIMPO: conforma #StructuralCheck, materializa exatamente o item 5(a) do adr-144,
		born-warn e dormant-safe (0 manifests -> 0 violacoes). cue vet pass.
		"""

	singleRoundRationale: """
		1 round: os 3 checks materializam o item 5(a) (ja isolada-revisado no adr-144), conformam a uniao
		discriminada do #StructuralCheck (cue vet) e sao dormant-safe — sem fail a corrigir.
		"""
}
