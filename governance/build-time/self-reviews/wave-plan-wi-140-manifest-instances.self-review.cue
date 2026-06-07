package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

wavePlanWi140: build_time.#SelfReviewReport & {
	reportId: "srr-wave-plan-wi-140-manifest-instances"

	artifactPath:       "governance/wave-plan.cue"
	artifactSchemaPath: "architecture/artifact-schemas/wave-plan.cue"
	artifactType:       "wave-plan"

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
		infoCount: 1
		summary: """
			Self-review em sessao: insercao de WI-140 (materializar instancias de PortManifest/
			AggregateManifest) em nova sub-wave W006-manifest-instances. Conforma #WavePlan/#Wave/#WaveTask:
			_allTaskIDs list.UniqueItems (WI-140 unico) e _depsCheck (dependsOn WI-103 resolve; WI-103 existe
			5x no plano) — ambos impostos por cue vet (pass). outputs como templates contexts/{bc}/
			port-manifest.cue + .../aggregate-manifests/am-*.cue (per 'nao cravar' quais BCs/aggregates).
			work-graph.cue NAO exige co-update (cobre so W001-W005; W006+ ja vive so no wave-plan —
			precedente WI-133..139). cue vet pass. 1 info: o arquivo carrega drift de cue fmt repo-wide
			pre-existente (waves em col-7), nao introduzido por este edit (diff = so o bloco WI-140).
			"""
	}]

	findings: {}

	summary: """
		wave-plan.cue (WI-140 em W006-manifest-instances; dependsOn WI-103). Self-review LIMPO: conforma
		#WavePlan (unicidade de id + resolucao de dependsOn via cue vet), outputs como templates, sem
		co-update de work-graph (W006+ fora dele). cue vet pass. 1 info: drift de fmt repo-wide
		pre-existente (nao deste edit).
		"""

	singleRoundRationale: """
		1 round: o #WavePlan impoe unicidade de WI-140 e resolucao de dependsOn WI-103 via cue vet (ambos
		pass); a insercao e um append de wave coerente com o padrao de sub-waves de W006 — sem fail.
		"""
}
