package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-009": artifact_schemas.#DeferredDecision & {
	id:    "def-009"
	title: "Policy lifecycle/versioning semantics — rollout, compatibility, deprecation, upgrade"
	date:  "2026-05-03"

	description: """
		Schema #Policy v1 declara version: int simples — increment
		quando policy muda materialmente. Lifecycle sofisticado deferido:
		(a) rollout phasing (canary, gradual, big-bang); (b) compatibility
		matrices (qual versão é backward/forward compatible); (c)
		deprecation semantics (when to retire old version, grace period);
		(d) upgrade triggers (breaking vs non-breaking version increments,
		consumer notification). Decisão depende de volume + concrete
		migration cases.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-065-establish-policy-registry-as-supporting-subdomain.cue",
		"governance/build-time/task-specs/wi-040.cue",
		"session:resume-mesh-work-jv2mc",
	]

	deferralRationale: """
		Lifecycle/versioning sofisticado é solution-in-search-of-problem
		até 1ª policy ter version > 1 com migration concreta. Schema
		v1 declara apenas version: int — substantividade do increment
		é discipline (tq-pol-04 warn). Sem migration cases, rollout
		semantics + compatibility matrices + deprecation lifecycle são
		over-specification. Custo de continuar deferindo: zero HOJE
		(version: 1 default); cresce quando 1ª policy precisar bump
		para version: 2 com clientes existentes.
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence file-content) detecta version increment
		via pattern 'version:\\s+[2-9]' — qualquer file com version
		field >= 2. Calibration challenge: pattern matches NÃO apenas
		policy files mas também outros artifacts com 'version:' field
		(e.g., task-specs com version: 2, lens prose discutindo event
		versioning). Verified at calibration time: 2 baseline matches
		em files non-policy (architecture/lenses/lens-platform-
		evolution-and-backwards-compatibility.cue prose + governance/
		build-time/task-specs/wi-027.cue task version=2). Threshold=3
		absorve esses 2 baseline + exige 1 actual policy file com
		version >= 2 = sinal genuíno de policy version increment.
		Limitation reconhecida: trigger não path-filterable em
		recurrence kind atual; bumping threshold é workaround
		conservador em vez de pattern overly narrow. Para 1ª version
		increment (sinal mais precoce), manual-review captura.
		Trigger 2 (manual-review) escape para priorização antecipada
		— e.g., quando founder antecipa que próxima session vai bump
		version de policy regulatória existente.
		"""

	costOfDeferral: {
		severity: "low"
		blastRadius: "cross-artifact"
		description: """
			Com todas policies em version 1, lifecycle é abstrato.
			Severity low HOJE; cresce quando 1ª policy bump version
			com consumers existentes. blastRadius cross-artifact
			porque lifecycle semantics afetam todas instances + suas
			references (cross-context-flow policyRefs, agent
			governance, etc.).
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "version:\\s+[2-9]"
		scope:     "file-content"
		threshold: 3
	}, {
		kind:   "manual-review"
		reason: "Founder pode priorizar lifecycle framework antes de 3ª match — e.g., 1ª policy version increment materializando (recurrence absorve 2 baseline non-policy matches) OR regulatory change antecipada (Bacen norm update) implica bump iminente exigindo migration semantics articulada."
	}]

	status: "open"
}
